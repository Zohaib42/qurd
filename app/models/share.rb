class Share < ApplicationRecord
  belongs_to :member
  belongs_to :post, counter_cache: true
  has_many :notifications, as: :notifiable, dependent: :destroy
end
