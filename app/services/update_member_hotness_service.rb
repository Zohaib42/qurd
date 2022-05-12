class UpdateMemberHotnessService
  attr_accessor :member

  def initialize(member)
    self.member = member
  end

  def update_score
    score = member.posts.order(score: :desc).limit(4).sum(:score)

    member.update_attribute('score', score.to_f)
  end
end
