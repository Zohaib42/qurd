require 'rails_helper'

describe Instructor do
  let(:instructor_user) { create :instructor }

  describe '#admin?' do
    it 'returns false' do
      expect(instructor_user.admin?).to be false
    end
  end

  describe '#student?' do
    it 'returns false' do
      expect(instructor_user.student?).to be false
    end
  end

  describe '#instructor?' do
    it 'returns true' do
      expect(instructor_user.instructor?).to be true
    end
  end
end
