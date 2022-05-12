class UpsertTalkjsMemberJob < ApplicationJob
  def perform(member)
    TalkJs::UpsertMember.call(member)
  end
end
