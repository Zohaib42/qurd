require 'rails_helper'

RSpec.describe CommentTag, type: :model do
  let(:comment_tag) { build :comment_tag }

  context 'associations' do
    it { should belong_to(:member) }
    it { should belong_to(:comment) }
  end
end
