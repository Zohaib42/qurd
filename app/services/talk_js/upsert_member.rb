module TalkJs
  class UpsertMember < Base
    attr_reader :member

    def initialize(member)
      @member = member
    end

    def call
      result = put("/users/#{talk_id}", payload)
      member.update_column(:talk_id, talk_id) if result.success?

      ServiceResponse.new data: result
    end

    private

    def talk_id
      @talk_id ||= member.talk_id.presence || Digest::MD5.hexdigest([Time.zone.now, member.id].join)[0...8]
    end

    def payload
      params = { name: member.name, email: [member.email], custom: { username: member.username } }
      params[:photoUrl] = member.avatar_url if member.image.attached?

      params
    end
  end
end
