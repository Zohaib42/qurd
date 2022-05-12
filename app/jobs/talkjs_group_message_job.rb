class TalkjsGroupMessageJob < ApplicationJob
  def perform(group, message)
    TalkJs::SystemMessage.call(group, message)
  end
end
