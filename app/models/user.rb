class User < ApplicationRecord
  has_person_name

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :invitable

  validates :first_name, :last_name, presence: true

  has_one_attached :avatar

  def admin?
    false
  end

  def student?
    false
  end

  def instructor?
    false
  end
end
