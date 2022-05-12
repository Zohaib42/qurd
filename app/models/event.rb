class Event < ApplicationRecord
  has_one_attached :cover
  has_many :rsvps, dependent: :destroy
  has_many :members, through: :rsvps

  validates :title, :start_at, presence: true
  validate  :ensure_start_date

  def date_range
    return start_at.strftime("%B %d, %Y") if end_at.blank?

    "#{start_at.strftime("%B %d")} - #{end_at.strftime("%B %d, %Y")}"
  end

  def ensure_start_date
    return if start_at.blank? || end_at.blank?

    errors.add(:start_at, "Start date can't be greater than end date.") if start_at > end_at
  end
end
