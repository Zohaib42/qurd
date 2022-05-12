json.id event.id
json.title event.title
json.description event.description
json.price event.price
json.cover_url event.cover.url
json.where event.location
json.date_rang event.date_range

json.members event.members do |member|
  json.partial! 'api/v1/members/member', member: member
end
