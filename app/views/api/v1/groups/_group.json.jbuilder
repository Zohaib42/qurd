json.call(group, :id, :name, :chat_type, :conversation_id, :last_message)

json.last_message_at "#{time_ago_in_words(group.last_message_time)} ago"
json.image group.image.url
json.is_admin group.creator_id == current_member.id

json.members group.members do |member|
  json.partial! 'api/v1/members/member', member: member
end
