require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { build :comment }

  context 'associations' do
    it { should belong_to(:author) }
    it { should belong_to(:post) }
  end

  context 'with validations' do
    it 'should have atleast one letter' do
      comment.content = ''

      expect(comment.valid?).to eq(false)
    end
  end
end
