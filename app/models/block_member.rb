class BlockMember < ApplicationRecord
  belongs_to :blocker, class_name: 'Member'
  belongs_to :member
end
