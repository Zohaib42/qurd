# frozen_string_literal: true

class MemberInterest < ApplicationRecord
  belongs_to :skill
  belongs_to :member

  validates :skill_id, uniqueness: { scope: [:member_id] }
end
