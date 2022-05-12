module TalkJs
  class ReadGroupConversation < Base
    attr_reader :group, :member

    def initialize(group, member)
      @group = group
      @member = member
    end

    def call
      result = post("/conversations/#{group.conversation_id}/readBy/#{member.talk_id}")

      ServiceResponse.new data: result, status: result.success? ? :ok : :unprocessable_entity
    end
  end
end
