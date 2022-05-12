class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :latest, ->(column: :created_at, sort: :desc) { order(column => sort) }
end
