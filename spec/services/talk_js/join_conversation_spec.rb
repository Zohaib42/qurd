require 'swagger_helper'

RSpec.describe TalkJs::JoinConversation do
  let!(:member) { create :member }
  let!(:group) { create :group }
  let(:first_member) { create :group_member, group: group, member: member }

  describe '#Talk JS Join Conversation' do
    let(:httparty_response) { instance_double(HTTParty::Response, success?: is_successfull) }

    context 'When successfull TalkJS PUT request' do
      let(:is_successfull) { true }

      before do
        allow(described_class).to receive(:put).and_return(httparty_response)
      end

      it do
        result = described_class.call(group, member)

        expect(result.valid?).to be_truthy
      end
    end

    context 'When un-successfull TalkJS PUT request' do
      let(:is_successfull) { false }

      before do
        allow(described_class).to receive(:put).and_return(httparty_response)
      end

      it do
        result = described_class.call(group, member)

        expect(result.valid?).to be_falsey
      end
    end
  end
end
