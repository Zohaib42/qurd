module TalkJs
  class LeaveConversation < Base
    attr_reader :group, :member

    def initialize(group, member)
      @group = group
      @member = member
    end

    def call
      result = delete("/conversations/#{group.conversation_id}/participants/#{member.talk_id}")

      ServiceResponse.new data: result, status: result.success? ? :ok : :unprocessable_entity
    end
  end
end
