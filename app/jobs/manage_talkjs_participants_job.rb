class ManageTalkjsParticipantsJob < ApplicationJob
  def perform(group, member, type)
    klass = "TalkJs::#{type.classify}Conversation".constantize.call(group, member)
  end
end
