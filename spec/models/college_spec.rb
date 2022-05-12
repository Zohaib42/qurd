require 'rails_helper'

RSpec.describe College, type: :model do
  let(:college) { build :college }

  context 'associations' do
    it { should have_many(:college_domains) }
  end

  context 'with validations' do
    it { should validate_presence_of(:name) }
    # it { should validate_numericality_of(:lat) }
    # it { should validate_numericality_of(:lng) }

    context 'in-valid name not present' do
      it 'should return college invalid' do
        college.assign_attributes(name: nil)

        expect(college.valid?).to be false
        expect(college.errors[:name].present?).to be true
      end
    end

    # context 'in-valid lat not present' do
    #   it 'should return college invalid' do
    #     college.assign_attributes(lat: nil)

    #     expect(college.valid?).to be false
    #     expect(college.errors[:lat].present?).to be true
    #   end
    # end

    # context 'in-valid lng not present' do
    #   it 'should return college invalid' do
    #     college.assign_attributes(lng: nil)

    #     expect(college.valid?).to be false
    #     expect(college.errors[:lng].present?).to be true
    #   end
    # end

    # context 'in-valid lat should be a decimal' do
    #   it 'should return college invalid' do
    #     college.assign_attributes(lat: 'lat')

    #     expect(college.valid?).to be false
    #     expect(college.errors[:lat].present?).to be true
    #   end
    # end
  end
end
