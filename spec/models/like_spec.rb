require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like) { build :like }

  context 'associations' do
    it { should belong_to(:member) }
    it { should belong_to(:post) }
  end
end
