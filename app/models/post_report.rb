class PostReport < ApplicationRecord
  belongs_to :post
  belongs_to :reporter, class_name: 'Member'

  STATUSES = {
    close: 'close',
    open: 'open'
  }.freeze

  enum status: STATUSES
end
