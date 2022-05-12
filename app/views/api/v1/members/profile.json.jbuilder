json.call(@member, :id, :email, :username, :name, :pronouns, :star_sign, :university, :avatar_url, :website_url, :talk_id, :talk_signature)
json.mobile @member.mobile if current_member.id == @member.id
json.posts_count @posts_count
json.following_count @following_count
json.followers_count @followers_count
json.followed_by_current_member current_member.following_user?(@member.id)

json.auth_token @member.generate_jwt
json.confirmed @member.confirmed?
json.direct_chat_conversation_id current_member.direct_chat_with(@member.id)

json.skills @member.skills do |skill|
  json.partial! 'skills', skill: skill
end

json.looking_for @member.interests do |skill|
  json.partial! 'skills', skill: skill
end

json.portfolio_posts @portfolio_posts do |post|
  json.partial! 'api/v1/posts/post', post: post
end

json.posts @posts do |post|
  json.partial! 'api/v1/posts/post', post: post
end

json.shares @shares do |share|
  json.partial! 'api/v1/shares/share', share: share
end

json.meta @meta
