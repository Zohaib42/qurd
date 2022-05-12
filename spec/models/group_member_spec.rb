require 'rails_helper'

RSpec.describe GroupMember, type: :model do
  let(:group_member) { build :group_member }

  context 'associations' do
    it { should belong_to(:member) }
    it { should belong_to(:group) }
  end
end
