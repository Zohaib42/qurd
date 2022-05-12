require 'rails_helper'

RSpec.describe TalkJs::SystemMessage do
  let(:member) { create :member }
  let(:new_member) { create :member }
  let(:group) { create :group, creator: member }
  let(:first_member) { create :group_member, group: group, member: member }
  let(:last_member) { create :group_member, group: group, member: new_member }
  let(:system_message) { "#{new_member.username} is left from group" }

  describe '#Talk JS SystemMessage' do
    let(:httparty_response) { instance_double(HTTParty::Response, success?: is_successfull) }

    context 'When successfull TalkJS Post request' do
      let(:is_successfull) { true }

      before do
        allow(described_class).to receive(:post).and_return(httparty_response)
      end

      it do
        result = described_class.call(group, system_message)

        expect(result.valid?).to be_truthy
      end
    end

    context 'When un-successfull TalkJS Post request' do
      let(:is_successfull) { false }

      before do
        allow(described_class).to receive(:post).and_return(httparty_response)
      end

      it do
        result = described_class.call(group, system_message)

        expect(result.valid?).to be_falsey
      end
    end
  end
end
