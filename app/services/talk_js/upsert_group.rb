module TalkJs
  class UpsertGroup < Base
    attr_reader :group

    def initialize(group)
      @group = group
    end

    def call
      result = put("/conversations/#{conversation_id}", payload)
      group.update_column(:conversation_id, conversation_id) if result.success?

      ServiceResponse.new data: result
    end

    private

    def conversation_id
      @conversation_id ||= group.conversation_id.presence || Digest::MD5.hexdigest([Time.zone.now, group.id].join)[0...8]
    end

    def payload
      params = {
        participants: group.members.pluck(:talk_id).reject(&:blank?),
        subject: group.name
      }
      params[:photoUrl] = group.image.url if group.image.attached?

      params
    end
  end
end
