class UpdatePostHotnessService
  attr_accessor :post, :total_likes, :total_shares

  def initialize(post:, total_likes:, total_shares:)
    self.post = post
    self.total_likes = total_likes
    self.total_shares = total_shares
  end

  def update_score
    score = age_weight * applause_weight * echos_weight * comments_weight

    post.update_attribute('score', score.to_f.round(10))
  end

  private

  def age_weight
    return 0 if post.created_at < TIMEFRAME.minutes.ago

    unit_age_value = 1.5 / TIMEFRAME

    (TIMEFRAME - ((Time.now - post.created_at) / 60)) * unit_age_value
  end

  def applause_weight
    total_likes > 0 ? post.likes_count.to_f / total_likes.to_f : 0.001
  end

  def echos_weight
    total_shares > 0 ? post.shares_count.to_f / total_shares.to_f : 0.01
  end

  def comments_weight
    return 0.01 if post.comments.where('created_at > ?', 48.hours.ago).any?

    0.005
  end
end
