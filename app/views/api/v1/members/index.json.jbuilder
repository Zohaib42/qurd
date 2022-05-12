json.members @members do |member|
  json.id member.id
  json.username member.username
  json.avatar_url member.image.url
  json.university member.university
  json.skills member.skills, :id, :name, :creatives
  json.website_url member.website_url
  json.followed_by_current_member current_member.following_user?(member.id)
end
json.meta @pagy.meta
