require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user, email: 'hello@world.com') }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }

  context 'when successful' do
    it { is_expected.not_to be_nil }
    it { expect(user.save).to be true }

    context 'with attributes' do
      before { user.save }

      it { expect(user.password).to eq('password') }
      it { expect(user.email).to eq('hello@world.com') }
    end
  end

  describe 'user has uploaded its Avatar' do
    it 'is valid' do
      user.avatar.attach(io: File.open("#{::Rails.root}/spec/dummy_image.jpg"), filename: 'attachment.jpg', content_type: 'image/jpg')
      expect(user.avatar).to be_attached
    end
  end

  context 'when not successful' do
    context 'with wrong email' do
      it 'without @ sign' do
        check_valid?(user, :email, 'test1email.com', ['Email is invalid'])
      end

      it 'with space in email' do
        check_valid?(user, :email, 'test 1@email.com', ['Email is invalid'])
      end

      it 'with space and without @ sign in email' do
        check_valid?(user, :email, 'test 1email.com', ['Email is invalid'])
      end

      it 'without @ and . sign in email' do
        check_valid?(user, :email, 'test1emailcom', ['Email is invalid'])
      end
    end

    context 'when password' do
      let(:user) { build(:user, password: password, password_confirmation: 'pass') }

      before { user.valid? }

      context 'with no characters' do
        let(:password) { nil }

        it { expect(user.errors.full_messages).to eq(["Password can't be blank", "Password confirmation doesn't match Password"]) }
      end

      context 'with shorter less than 6 characters' do
        let(:password) { 'pass' }

        it { expect(user.errors.full_messages).to eq(['Password is too short (minimum is 6 characters)']) }
      end
    end
  end
end
