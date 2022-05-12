class MemberReport < ApplicationRecord
  belongs_to :reported, class_name: 'Member'
  belongs_to :reporter, class_name: 'Member'

  STATUSES = {
    close: 'close',
    open: 'open'
  }.freeze

  enum status: STATUSES
end
