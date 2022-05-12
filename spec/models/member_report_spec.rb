require 'rails_helper'

RSpec.describe MemberReport, type: :model do
  let(:member_report) { build :member_report }

  context 'associations' do
    it { should belong_to(:reported) }
    it { should belong_to(:reporter) }
  end
end
