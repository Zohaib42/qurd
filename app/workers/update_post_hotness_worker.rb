# frozen_string_literal: true

class UpdatePostHotnessWorker
  include Sidekiq::Worker

  def perform
    posts.find_each do |post|
      UpdatePostHotnessService.new(
        post: post,
        total_likes: total_likes,
        total_shares: total_shares
      ).update_score
    end
  end

  private

  def posts
    @posts ||= Post.where('created_at > ?', TIMEFRAME.minutes.ago)
  end

  def total_likes
    @total_likes ||= posts.sum(:likes_count)
  end

  def total_shares
    @total_shares ||= posts.sum(:shares_count)
  end
end
