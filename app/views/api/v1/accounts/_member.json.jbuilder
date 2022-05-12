json.id member.id
json.username member.username
json.avatar_url member.avatar_url
json.talk_id member.talk_id
json.talk_signature member.talk_signature
json.university member.university

json.skills member.skills.first(3).each do |skill|
  json.id skill.id
  json.name skill.name
end
