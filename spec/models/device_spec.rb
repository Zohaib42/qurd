require 'rails_helper'

RSpec.describe Device, type: :model do
  let(:subject) { build :device }

  context 'associations' do
    it { should belong_to(:member) }
  end

  context 'validations' do
    it { should validate_presence_of(:token) }
    it { should validate_presence_of(:platform) }
    it { should validate_inclusion_of(:platform).in_array(Device::PLATFORMS) }
  end
end
