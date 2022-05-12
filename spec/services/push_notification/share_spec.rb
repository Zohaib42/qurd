require 'rails_helper'

RSpec.describe PushNotification::Share do
  let(:member) { create :member }
  let(:post) { create :post }

  describe 'push notification for share' do
    let!(:device) { create :device, member: post.creator }
    let(:share) { create :share, member: member, post: post }

    before { dump_rpush }

    it { expect { described_class.call(post.creator, member, share.post) }.to change { Rpush::Gcm::Notification.count }.by(1) }
  end
end
