class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'Member'
  belongs_to :followed, class_name: 'Member'

  validates_uniqueness_of :follower_id, scope: :followed_id
end
