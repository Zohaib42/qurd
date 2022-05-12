json.id comment.id
json.content comment.content
json.created_at comment.created_at
json.author comment.author, :id, :username, :avatar_url

json.tagged_members comment.tagged_members do |tagged_member|
  json.partial! 'api/v1/members/member', member: tagged_member
end
