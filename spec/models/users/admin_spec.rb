require 'rails_helper'

describe Admin do
  let(:admin_user) { create :admin }

  describe '#admin?' do
    it 'returns true' do
      expect(admin_user.admin?).to be true
    end
  end

  describe '#student?' do
    it 'returns false' do
      expect(admin_user.student?).to be false
    end
  end

  describe '#instructor?' do
    it 'returns false' do
      expect(admin_user.instructor?).to be false
    end
  end
end
