require 'rails_helper'

RSpec.describe CollegeDomain, type: :model do
  let(:college_domain) { build :college_domain }

  context 'associations' do
    it { should belong_to(:college) }
  end

  context 'with validations' do
    it { should validate_presence_of(:domain) }

    context 'in-valid domain not present' do
      it 'should return college_domain invalid' do
        college_domain.assign_attributes(domain: nil)

        expect(college_domain.valid?).to be false
        expect(college_domain.errors[:domain].present?).to be true
      end
    end

  end
end
