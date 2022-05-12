require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { build :notification }

  context 'associations' do
    it { should belong_to(:recipient) }
    it { should belong_to(:notifier) }
  end

  context 'validations' do
    it 'should return invalid notification' do
      notification.assign_attributes(title: nil)

      expect(notification.valid?).to be false
      expect(notification.errors[:title].present?).to be true
    end
  end
end
