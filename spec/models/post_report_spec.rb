require 'rails_helper'

RSpec.describe PostReport, type: :model do
  let(:post_report) { build :post_report }

  context 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:reporter) }
  end
end
