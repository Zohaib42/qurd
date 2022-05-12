require 'rails_helper'

RSpec.describe BlockMember, type: :model do
  let(:block_member) { build :block_member }

  context 'associations' do
    it { should belong_to(:blocker) }
    it { should belong_to(:member) }
  end
end
