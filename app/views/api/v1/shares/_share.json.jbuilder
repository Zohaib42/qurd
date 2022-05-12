json.partial! 'api/v1/posts/post', post: share.post
json.shared_member do
  json.partial! 'api/v1/members/member', member: share.member
end
