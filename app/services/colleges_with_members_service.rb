class CollegesWithMembersService
  attr_accessor :scope

  def initialize(scope)
    self.scope = scope
  end

  def call
    scope.map { |obj| DecorateCollegeWithMembers.call(obj, members) }
  end

  private

  def members
    @members ||= Member.where("SPLIT_PART(email, '@', 2) IN (?)", domains).with_attached_image
  end

  def domains
    @domains ||= CollegeDomain.pluck(:domain)
  end
end
