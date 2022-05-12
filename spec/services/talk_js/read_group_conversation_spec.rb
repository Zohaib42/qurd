require 'swagger_helper'

RSpec.describe TalkJs::ReadGroupConversation do
  let!(:member) { create :member }
  let!(:new_member) { create :member }
  let!(:group) { create :group, members: [member, new_member] }

  describe 'TalkJs Read Group Conversation' do
    let(:httparty_response) { instance_double(HTTParty::Response, success?: is_successfull) }

    context 'When successfull TalkJS post request' do
      let(:is_successfull) { true }

      before do
        allow(described_class).to receive(:post).and_return(httparty_response)
      end

      it do
        result = described_class.new(group, member).call()

        expect(result.valid?).to be_truthy
      end
    end

    context 'When un-successfull TalkJS post Response' do
      let(:is_successfull) { false }

      before do
        allow(described_class).to receive(:post).and_return(httparty_response)
      end

      it do
        result = described_class.new(group, member).call()

        expect(result.valid?).to be_falsey
      end
    end
  end
end
