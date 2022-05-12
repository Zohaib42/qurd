require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { build :event }

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:start_at) }

    context 'not valid event' do
      it 'should return invalid event' do
        event.assign_attributes(start_at: Date.today + 1)
        event.assign_attributes(end_at: Date.today)

        expect(event.valid?).to eq false
        expect(event.errors['start_at'].present?).to eq true
      end
    end
  end
end
