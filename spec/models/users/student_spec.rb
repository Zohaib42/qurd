require 'rails_helper'

describe Student do
  let(:student_user) { create :student }

  describe '#admin?' do
    it 'returns false' do
      expect(student_user.admin?).to be false
    end
  end

  describe '#student?' do
    it 'returns true' do
      expect(student_user.student?).to be true
    end
  end

  describe '#instructor?' do
    it 'returns false' do
      expect(student_user.instructor?).to be false
    end
  end
end
