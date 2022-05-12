json.feed do
  json.posts @posts do |post|
    json.partial! 'api/v1/posts/post', post: post
  end

  json.video_posts @video_posts do |post|
    json.partial! 'api/v1/posts/post', post: post
  end

  json.image_posts @image_posts do |post|
    json.partial! 'api/v1/posts/post', post: post
  end

  json.text_posts @text_posts do |post|
    json.partial! 'api/v1/posts/post', post: post
  end

  json.audio_posts @audio_posts do |post|
    json.partial! 'api/v1/posts/post', post: post
  end

  json.skills @skills do |skill|
    json.partial! 'api/v1/skills/skill', skill: skill
  end

  json.suggested_members @suggested_members do |member|
    json.partial! 'api/v1/accounts/member', member: member
  end
end
