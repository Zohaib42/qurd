require 'rails_helper'

RSpec.describe PushNotification::Post do
  let(:member) { create :member, :with_follower }
  let(:post) { create :post, creator: member }

  describe 'push notification on new post' do
    let!(:device) { create :device, member: member.followers.first }

    before { dump_rpush }

    it { expect { described_class.call(member.followers.first, member, post) }.to change { Rpush::Gcm::Notification.count }.by(1) }
  end
end
