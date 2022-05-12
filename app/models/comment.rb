class Comment < ApplicationRecord
  belongs_to :author, class_name: 'Member'
  belongs_to :post, counter_cache: true

  has_many :comment_tags, dependent: :destroy
  has_many :tagged_members, through: :comment_tags, source: :member
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :content, presence: true
end
