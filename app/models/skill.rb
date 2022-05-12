# frozen_string_literal: true

class Skill < ApplicationRecord
  NAME_REGEX = /\A[[:alpha:][:blank:]]+\z/

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :creatives, numericality: { only_integer: true }, allow_blank: true

  belongs_to :author, class_name: 'Member', optional: true

  def refresh_creative_count
    update(creatives: MemberSkill.joins(:member).where(skill_id: id).size)
  end
end
