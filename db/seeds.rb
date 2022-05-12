# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

colleges = [
  { name: "University of Oxford", lat: 51.7548, lng: 1.2544 },
  { name: "University of Melbourne", lat: 37.7983, lng: 144.9610 },
  { name: "Northeastern University", lat: 42.3398, lng: 71.0892 },
  { name: "University of Cambridge", lat: 52.2043, lng: 0.1149 },
]

colleges.each do |attrs|
  college = College.where(name: attrs[:name]).first_or_initialize
  college.update(attrs)
end

college_domains = [
  { college_id: 1, domain: "oxford.edu.eng" },
  { college_id: 2, domain: "melbourne.edu.aus" },
  { college_id: 3, domain: "northeastren.edu.ma" },
  { college_id: 4, domain: "cambridge.edu.eng" },
]

college_domains.each do |attrs|
  college_domain = CollegeDomain.where(domain: attrs[:domain]).first_or_initialize
  college_domain.update(attrs)
end

skills = [
  { name: "Songwriter", creatives: 103 },
  { name: "Producer", creatives: 70 },
  { name: "Vocalist", creatives: 50 },
  { name: "Band", creatives: 46 },
  { name: "Rapper", creatives: 32 },
]

skills.each do |attrs|
  skill = Skill.where(name: attrs[:name]).first_or_initialize
  skill.update(attrs)
end

emails = [
  "nkdev@mailinator.com",
  "abc@oxford.edu.eng",
  "xyz@melbourne.edu.aus",
  "cdf@northeastren.edu.ma",
  "jkl@mailinator.com",
]

emails.each do |email|
  member = Member.where(email: email).first_or_initialize
  attrs = {
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    password: 'password',
    mobile: FFaker::PhoneNumber.short_phone_number,
    username: FFaker::Internet.user_name,
    confirmed_at: Time.now
  }

  member.assign_attributes(attrs)
  member.skip_confirmation!
  member.save(validate: false)
end

skill = Skill.first

member_skills = [
  { member: Member.first, skill: skill },
  { member: Member.second, skill: skill },
  { member: Member.third, skill: skill },
]

member_skills.each do |attrs|
  member_skill = MemberSkill.where(member: attrs[:member], skill: attrs[:skill]).first_or_initialize
  member_skill.save
end

relationships = [
  { follower_id: 1, followed_id: 2 },
  { follower_id: 1, followed_id: 3 },
  { follower_id: 2, followed_id: 1 },
  { follower_id: 2, followed_id: 3 },
  { follower_id: 2, followed_id: 4 },
  { follower_id: 3, followed_id: 1 },
  { follower_id: 3, followed_id: 2 },
  { follower_id: 3, followed_id: 5 },
]

relationships.each do |attrs|
  relationship = Relationship.where(follower_id: attrs[:follower_id], followed_id: attrs[:followed_id])
                             .first_or_initialize

  relationship.save
end

first_creator_id = Member.first&.id
second_creator_id = Member.second&.id
third_creator_id = Member.third&.id

posts = [
  { title: "abc", post_type: "image", share_type: 'link', link: 'www.google.com', description: "abc description", creator_id: first_creator_id },
  { title: "efg", post_type: "video", share_type: 'link', link: 'www.google.com', description: "efg description", creator_id: first_creator_id },
  { title: "hij", post_type: "text", share_type: 'link', link: 'www.google.com', description: "hij description", creator_id: first_creator_id },
  { title: "xyz", post_type: "video", share_type: 'link', link: 'www.google.com', description: "xyz description", creator_id: first_creator_id },
  { title: "klm", post_type: "image", share_type: 'link', link: 'www.google.com', description: "klm description", creator_id: second_creator_id },
  { title: "nop", post_type: "video", share_type: 'link', link: 'www.google.com', description: "nop description", creator_id: second_creator_id },
  { title: "abc", post_type: "text", share_type: 'link', link: 'www.google.com', description: "abc description", creator_id: second_creator_id },
  { title: "ghi", post_type: "image", share_type: 'link', link: 'www.google.com', description: "ghi description", creator_id: second_creator_id },
  { title: "abc", post_type: "image", share_type: 'link', link: 'www.google.com', description: "abc description", creator_id: third_creator_id },
  { title: "lmn", post_type: "image", share_type: 'link', link: 'www.google.com', description: "lmn description", creator_id: third_creator_id },
  { title: "abc", post_type: "video", share_type: 'link', link: 'www.google.com', description: "abc description", creator_id: third_creator_id },
  { title: "lmn", post_type: "image", share_type: 'link', link: 'www.google.com', description: "lmn description", creator_id: third_creator_id },
  { title: "pqr", post_type: "video", share_type: 'link', link: 'www.google.com', description: "pqr description", creator_id: third_creator_id },
  { title: "abc", post_type: "image", share_type: 'link', link: 'www.google.com', description: "abc description", creator_id: third_creator_id },
  { title: "qrs", post_type: "image", share_type: 'link', link: 'www.google.com', description: "qrs description", creator_id: third_creator_id },
]

posts.each do |attrs|
  post = Post.where(title: attrs[:title], post_type: attrs[:post_type]).first_or_initialize
  post.assign_attributes(attrs)
  post.save validate: false
end
