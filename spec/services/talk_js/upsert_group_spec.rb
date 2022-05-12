require 'swagger_helper'

RSpec.describe TalkJs::UpsertGroup do
  let(:member) { create :member }
  let(:new_member) { create :member }
  let(:group) { create :group, creator: member }
  let(:first_member) { create :group_member, group: group, member: member }
  let(:last_member) { create :group_member, group: group, member: new_member }

  describe '#Talk JS Upsert Group' do
    let(:httparty_response) { instance_double(HTTParty::Response, success?: is_successfull) }

    context 'When successfull TalkJS PUT request' do
      let(:is_successfull) { true }

      before do
        allow(TalkJs::UpsertGroup).to receive(:put).and_return(httparty_response)

        described_class.call(group)
      end

      it { expect(group.conversation_id.present?).to be_truthy }
    end

    context 'When un-successfull TalkJS PUT request' do
      let(:is_successfull) { false }

      before do
        allow(TalkJs::UpsertGroup).to receive(:put).and_return(httparty_response)

        described_class.call(group)
      end

      it { expect(group.conversation_id.blank?).to be_truthy }
    end
  end
end
