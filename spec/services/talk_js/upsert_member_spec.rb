require 'swagger_helper'

RSpec.describe TalkJs::UpsertMember do
  let(:member) { create :member }

  describe '#Talk JS Upsert Member' do
    let(:httparty_response) { instance_double(HTTParty::Response, success?: is_successfull) }

    context 'When successfull TalkJS PUT request' do
      let(:is_successfull) { true }

      before do
        allow(TalkJs::UpsertMember).to receive(:put).and_return(httparty_response)

        described_class.call(member)
      end

      it { expect(member.talk_id.present?).to be_truthy }
    end

    context 'When un-successfull TalkJS PUT request' do
      let(:is_successfull) { false }

      before do
        allow(TalkJs::UpsertMember).to receive(:put).and_return(httparty_response)

        described_class.call(member)
      end

      it { expect(member.talk_id.blank?).to be_truthy }
    end
  end
end
