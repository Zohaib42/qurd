class CommentTag < ApplicationRecord
  belongs_to :comment
  belongs_to :member
end
