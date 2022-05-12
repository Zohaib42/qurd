class RetrieveSuggestedMembers
  attr_accessor :member

  def initialize(member)
    self.member = member
  end

  def fetch_data
    members = Member.joins(:member_skills, :member_interests).where(
      suggested_users_sql,
      member.skill_ids + member.interest_ids + [0],
      member.following_ids + [0] + member.blocked_members_ids,
      member.id
    ).order(score: :desc).limit(30).distinct

    Member.where(id: members.sample(10).pluck(:id)).includes(:skills)
  end

  private

  def suggested_users_sql
    "member_skills.skill_id IN (?)
      AND members.id NOT IN (?)
      AND NOT members.id = ?"
  end
end
