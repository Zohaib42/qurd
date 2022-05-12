class FilterMembersQuery
  attr_accessor :initial_scope, :current_member

  def initialize(initial_scope, current_member = Member.new)
    @initial_scope = initial_scope
    @current_member = current_member
  end

  def call(params = {})
    scoped = initial_scope.where.not(id: current_member.id)
    scoped = search_by_username(scoped, params[:term]) if params[:term].present?
    scoped = filter_by_possessed_skills(scoped, params[:skills]) if params[:skills]&.any?(&:present?)
    scoped = filter_by_looking_for_skills(scoped, params[:looking_for_skills]) if params[:looking_for_skills]&.any?(&:present?)
    scoped = filter_by_college_domain(scoped, params[:college_id]) if params[:college_id].present?
    scoped.distinct.with_attached_image
  end

  private

  def search_by_username(scoped, term)
    scoped.where('lower(username) ILIKE :term OR lower(first_name) ILIKE :term OR lower(last_name) ILIKE :term OR lower(email) ILIKE :term', term: "%#{term.downcase}%")
  end

  def filter_by_possessed_skills(scoped, skill_ids)
    scoped.joins(:member_skills).where(member_skills: { skill_id: skill_ids })
  end

  def filter_by_looking_for_skills(scoped, skill_ids)
    scoped.joins(:member_interests).where(member_interests: { skill_id: skill_ids })
  end

  def filter_by_college_domain(scoped, college_id)
    college = College.find_by(id: college_id)
    return scoped if college.blank?

    domains = college.college_domains.pluck :domain
    scoped.where("SPLIT_PART(email, '@', 2) IN (?)", domains)
  end
end
