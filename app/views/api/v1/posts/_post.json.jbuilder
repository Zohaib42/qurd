json.id post.id
json.title post.title
json.post_type post.post_type
json.share_type post.share_type
json.description post.description
json.link post.link
json.asset_url post.attachment.url
json.score post.score.to_f
json.creator post.creator, :id, :username, :avatar_url

json.comments post.comments do |comment|
  json.partial! 'api/v1/comments/comment', comment: comment
end

json.total_comments post.comments_count
json.total_applauses post.likes_count
json.applause_by_current_member post.liked_by? current_member.id
json.first_four_users_avatars post.likes.first(4) do |like|
  json.avatar_url like.member.avatar_url
  json.username like.member.username
end

json.total_shares post.shares_count
json.echo_by_current_member post.shared_by? current_member.id
