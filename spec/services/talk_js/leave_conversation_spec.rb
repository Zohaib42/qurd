require 'swagger_helper'

RSpec.describe TalkJs::LeaveConversation do
  let!(:member) { create :member }
  let!(:group) { create :group }
  let(:first_member) { create :group_member, group: group, member: member }

  describe '#Talk JS Leave Conversation' do
    let(:httparty_response) { instance_double(HTTParty::Response, success?: is_successfull) }

    context 'When successfull TalkJS DELETE request' do
      let(:is_successfull) { true }

      before do
        allow(described_class).to receive(:delete).and_return(httparty_response)
      end

      it do
        result = described_class.call(group, member)

        expect(result.valid?).to be_truthy
      end
    end

    context 'When un-successfull TalkJS DELETE request' do
      let(:is_successfull) { false }

      before do
        allow(described_class).to receive(:delete).and_return(httparty_response)
      end

      it do
        result = described_class.call(group, member)

        expect(result.valid?).to be_falsey
      end
    end
  end
end
