class UpsertTalkjsGroupJob < ApplicationJob
  def perform(group)
    new_record = group.conversation_id.blank?

    TalkJs::UpsertGroup.call(group)
    TalkjsGroupMessageJob.perform_later(group.reload, "#{group.creator.username} created this group") if new_record
  end
end
