# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :member

  PLATFORMS = %w[ios android].freeze

  validates :token, :platform, presence: true
  validates :platform, inclusion: { in: PLATFORMS }
end
