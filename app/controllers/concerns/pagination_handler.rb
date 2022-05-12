# frozen_string_literal: true

module PaginationHandler
  extend ActiveSupport::Concern

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 100

  def paginate(relation)
    result = Paginator.new(relation, page, per_page).call

    [result, result.data]
  end

  def page
    @page ||= params.fetch(:page, DEFAULT_PAGE)
  end

  def per_page
    @per_page ||= params.fetch(:per_page, DEFAULT_PER_PAGE)
  end
end
