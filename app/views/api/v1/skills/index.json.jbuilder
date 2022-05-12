json.skills @skills do |skill|
  json.partial! 'skill', skill: skill
end
