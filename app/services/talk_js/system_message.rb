module TalkJs
  class SystemMessage < Base
    attr_reader :group, :message

    TYPE = 'SystemMessage'.freeze

    def initialize(group, message)
      @group = group
      @message = message
    end

    def call
      result = post("/conversations/#{group.conversation_id}/messages", payload)

      ServiceResponse.new data: result, status: result.success? ? :ok : :unprocessable_entity
    end

    private

    def payload
      [{ text: message, type: TYPE }]
    end
  end
end
