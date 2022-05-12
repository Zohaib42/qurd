require 'rails_helper'

RSpec.describe Skill, type: :model do
  subject { FactoryBot.build(:skill) }

  describe :validations do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
  end
end
