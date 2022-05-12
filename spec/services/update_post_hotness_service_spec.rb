require 'rails_helper'

RSpec.describe UpdatePostHotnessService do
  let(:member) { create :member }
  let(:post) { create :post }
  let!(:like) { create :like, member: member, post: post }
  let!(:share) { create :share, member: member, post: post }
  let!(:comment) { create :comment, post: post, author: member }
  let(:time) { Time.zone.now }
  let(:posts) { Post.where('created_at > ?', TIMEFRAME.minutes.ago) }
  let(:total_likes) { posts.sum(:likes_count) }
  let(:total_shares) { posts.sum(:shares_count) }

  describe '#update_score' do
    before do
      Timecop.freeze(time)
      post.update(created_at: time)
    end

    it 'calculates and updates the post score' do
      UpdatePostHotnessService.new(
        post: post,
        total_likes: total_likes,
        total_shares: total_shares
      ).update_score

      expect(post.reload.score).to eq(0.015)
    end

    it 'sets the score zero when post is one month old' do
      post.update(created_at: time - 1.month)

      UpdatePostHotnessService.new(
        post: post,
        total_likes: total_likes,
        total_shares: total_shares
      ).update_score

      expect(post.reload.score).to eq(0)
    end

    it 'sets the score to 0.000015' do
      like.destroy

      UpdatePostHotnessService.new(
        post: post,
        total_likes: total_likes,
        total_shares: total_shares
      ).update_score

      expect(post.reload.score).to eq(0.000015)
    end
  end
end
