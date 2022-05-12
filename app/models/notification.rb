class Notification < ApplicationRecord
  STATUSES = {
    read: 'read',
    unread: 'unread'
  }.freeze

  belongs_to :recipient, class_name: 'Member'
  belongs_to :notifier, class_name: 'Member'
  belongs_to :notifiable, polymorphic: true

  validates :title, presence: true

  enum status: STATUSES
end
