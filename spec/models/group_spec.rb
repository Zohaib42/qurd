require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:subject) { build :group }

  context 'associations' do
    it { should belong_to(:creator) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:chat_type) }
  end
end
