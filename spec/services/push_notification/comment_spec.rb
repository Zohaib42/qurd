require 'swagger_helper'

RSpec.describe PushNotification::Comment do
  let(:member) { create :member }
  let(:post) { create :post }

  describe 'Push notification for Like' do
    let!(:comment) { create :comment, post: post, author: member }
    let!(:device) { create :device, member: post.creator }

    before { dump_rpush }

    it { expect { described_class.call(post.creator, member, post, { comment: comment }) }.to change { Rpush::Gcm::Notification.count }.by(1) }
  end
end
