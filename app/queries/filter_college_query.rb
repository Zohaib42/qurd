class FilterCollegeQuery
  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params = {})
    scoped = initial_scope
    scoped = search_by_name(scoped, params[:term]) if params[:term].present?
    scoped
  end

  private

  def search_by_name(scoped, term)
    scoped.joins(:college_domains).where('lower(name) ILIKE :term OR lower(college_domains.domain) ILIKE :term', term: "%#{term.downcase}%")
  end
end
