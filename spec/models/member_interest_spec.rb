require 'rails_helper'

RSpec.describe MemberInterest, type: :model do
  subject { FactoryBot.build(:member_interest) }

  describe :associations do
    it { should belong_to(:skill) }
    it { should belong_to(:member) }
  end

  describe :validations do
    describe :uniqueness do
      it { is_expected.to validate_uniqueness_of(:skill_id).scoped_to(:member_id) }
    end
  end
end
