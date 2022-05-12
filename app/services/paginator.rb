# frozen_string_literal: true

class Paginator
  attr_reader :relation, :page, :per_page

  ALL = 'all'

  def initialize(relation, page, per_page)
    @relation = relation
    @page ||= page
    @per_page ||= per_page
  end

  def call
    page == ALL ? ServiceResponse.new(data: relation) : paginate
  end

  private

  def paginate
    collection = relation.page(page).per(per_page)

    ServiceResponse.new(data: collection, meta: meta(collection))
  end

  def meta(collection)
    {
      pages: {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    }
  end
end
