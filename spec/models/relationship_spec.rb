require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { build :relationship }

  context 'associations' do
    it { should belong_to(:follower) }
    it { should belong_to(:followed) }
  end
end
