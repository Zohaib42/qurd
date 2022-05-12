require 'swagger_helper'

RSpec.describe CollegesWithMembersService do
  let!(:first_member) { create :member }
  let!(:second_member) { create :member }

  describe '#call' do
    it 'returns colleges with members' do
      colleges = described_class.new(College.all).call

      expect(colleges.count).to eq 2
      expect(colleges.first.respond_to?(:members)).to eq true
    end
  end
end
