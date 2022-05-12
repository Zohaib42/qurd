class Like < ApplicationRecord
  belongs_to :member, inverse_of: :likes
  belongs_to :post, inverse_of: :likes, counter_cache: :likes_count
  has_many :notifications, as: :notifiable, dependent: :destroy
end
