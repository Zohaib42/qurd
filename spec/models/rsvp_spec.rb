require 'rails_helper'

RSpec.describe Rsvp, type: :model do
  let(:rsvp) { build :rsvp }

  context 'associations' do
    it { should belong_to(:member) }
    it { should belong_to(:event) }
  end
end
