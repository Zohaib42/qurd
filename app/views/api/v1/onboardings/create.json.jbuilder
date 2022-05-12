json.member do |json|
  json.pronouns @member.pronouns
  json.website_url @member.website_url
  json.star_sign @member.star_sign


  if @member.image.attached?
    json.image rails_representation_url(@member.image.variant(resize_to_limit: [500, 500]), only_path: true)
  end

  json.skills(@member.skills, :name, :creatives)
  json.interests(@member.interests, :name, :creatives)
end
