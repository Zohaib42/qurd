require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe '#show_avatar' do
    let!(:user) { create(:user, :with_avatar) }

    context 'when user avatar when present' do
      it 'returns avatar url' do
        image_url = image_tag(url_for(user.avatar), height: 30, class: 'd-inline-block align-top')
        expect(helper.show_avatar(user)).to eq(image_url)
      end
    end

    context 'when user avatar when not present' do
      let(:user_no_avatar) { build :user }

      it { expect(helper.show_avatar(user_no_avatar)).to eq("<i class='material-icons'>person</i>") }
    end
  end
end
