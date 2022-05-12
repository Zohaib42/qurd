class College < ApplicationRecord
  has_many :college_domains, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :college_domains, reject_if: :all_blank, allow_destroy: true

  def self.search(term)
    colleges = all
    colleges = colleges.where('lower(name) ILIKE ?', "%#{term}%") if term.present?
    colleges
  end

  def self.sort_by_members_count
    yield.sort_by do |college|
      college.members.count
    end.reverse
  end
end
