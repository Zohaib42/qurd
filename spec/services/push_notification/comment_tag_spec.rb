require 'swagger_helper'

RSpec.describe PushNotification::CommentTag do
  let(:member) { create :member }
  let(:post) { create :post }

  describe 'Push notification for comment tag' do
    let!(:comment) { create :comment, post: post, author: member }
    let!(:new_member) { create :member }
    let!(:device) { create :device, member: new_member  }
    let!(:comment_tag) { create :comment_tag, comment: comment, member: new_member }

    before { dump_rpush }

    it { expect { described_class.call(new_member, member, post, { comment: comment }) }.to change { Rpush::Gcm::Notification.count }.by(1) }
  end
end
