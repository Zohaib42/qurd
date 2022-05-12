json.posts @posts do |post|
  json.partial! 'api/v1/posts/post', post: post
end

json.shares @shares do |share|
  json.partial! 'api/v1/shares/share', share: share
end

json.meta @meta
