class CollegeDomain < ApplicationRecord
  belongs_to :college

  validates :domain, presence: true
  validates_uniqueness_of :domain, case_sensitive: false
  validates_format_of :domain, { with:  /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}\z/ix }

  def self.domain_mapping
    @domain_mapping  ||= includes(:college).collect { |college_domain| [college_domain.domain, college_domain.college.name] }.to_h
  end
end
