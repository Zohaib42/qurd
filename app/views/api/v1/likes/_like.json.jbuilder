json.call(like, :member_id, :post_id, :id, :created_at, :updated_at)

json.post do
  json.partial! 'api/v1/posts/post', post: like.post
end
