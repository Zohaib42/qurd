require 'rails_helper'

RSpec.describe Member, type: :model do
  let!(:member) { build :member }
  let(:subject) { member }

  context 'associations' do
    it { should have_many(:member_skills) }
    it { should have_many(:skills).through(:member_skills) }

    it { should have_many(:member_interests) }
    it { should have_many(:interests).through(:member_interests) }
  end

  context 'with validations' do
    it { should validate_length_of(:pronouns).is_at_most(20) }
    it { should validate_inclusion_of(:star_sign).in_array(Member::STAR_SIGNS) }
    it { is_expected.to allow_value(nil).for(:star_sign) }

    context 'when email' do
      it { is_expected.not_to allow_value('wrong_email_address').for(:email).with_message('Oops! This is not a valid email') }
      it { should validate_uniqueness_of(:email).case_insensitive.with_message('Oops! This email is already taken') }
    end

    it { is_expected.to validate_presence_of(:name).with_message('Oops! This is a mandatory field') }
    it { should validate_uniqueness_of(:username).case_insensitive.with_message('Oops! This username is already taken') }

    context 'in-valid US mobile number' do
      it 'should return member invalid' do
        member.assign_attributes(mobile: '03236386445')

        expect(member.valid?).to be false
        expect(member.errors[:mobile].present?).to be true
      end
    end

    context 'valid US mobile number' do
      it 'should return member valid' do
        member.assign_attributes(mobile: '(555) 555-1234')

        expect(member.valid?).to be true
        expect(member.errors[:mobile].present?).to be false
      end
    end

    context 'Validate email' do
      it 'should return member invalid' do
        member.assign_attributes(email: 'email@foo.com')

        expect(member.valid?).to be false
        expect(member.errors[:email].present?).to be true
      end
    end

    context 'Validate website_url' do
      it 'should return member invalid' do
        member.assign_attributes(website_url: 'ttp://example.com/file.html')

        expect(member.valid?).to be false
        expect(member.errors[:website_url].present?).to be true
      end
    end
  end

  describe '#generate_jwt' do
    let!(:jwt) { SecureRandom.hex(32) }

    before do
      member.skip_confirmation! && member.save

      allow(JWT).to receive(:encode).and_return(jwt)
    end

    it { expect(member.generate_jwt).to eq jwt }
  end


  describe :callbacks do
    context 'when member skill is destroyed' do
      it 'creatives count of skill is reduced by 1' do
        member = FactoryBot.create(:member)
        skill = FactoryBot.create(:skill, creatives: 0)
        member.skill_ids = [skill.id]
        member.save
        expect(skill.reload.creatives).to eq(1)

        member.skill_ids = []
        member.save
        expect(skill.reload.creatives).to eq(0)
      end
    end

    context 'when member skill is added' do
      it 'creatives count of skill is increased by 1' do
        skill = FactoryBot.create(:skill, creatives: 0)

        member_1 = FactoryBot.create(:member)
        member_1.skill_ids = [skill.id]
        member_1.save
        expect(skill.reload.creatives).to eq(1)

        member_2 = FactoryBot.create(:member)
        member_2.skill_ids = [skill.id]
        member_2.save
        expect(skill.reload.creatives).to eq(2)
      end
    end
  end
end
