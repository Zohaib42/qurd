module TalkJs
  class JoinConversation < Base
    attr_reader :group, :member

    def initialize(group, member)
      @group = group
      @member = member
    end

    def call
      result = put("/conversations/#{group.conversation_id}/participants/#{member.talk_id}", payload)

      ServiceResponse.new data: result, status: result.success? ? :ok : :unprocessable_entity
    end

    private

    def payload
      { notify?: true, access?: 'ReadWrite' }
    end
  end
end
