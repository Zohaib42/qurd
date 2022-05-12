json.id college.id
json.name college.name
json.members college.members do |member|
  json.partial! 'api/v1/members/member', member: member
end
