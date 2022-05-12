require 'rails_helper'

RSpec.describe Share, type: :model do
  let(:share) { build :share }

  context 'associations' do
    it { should belong_to(:member) }
    it { should belong_to(:post) }
  end
end
