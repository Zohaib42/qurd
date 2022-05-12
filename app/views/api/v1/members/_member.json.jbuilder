json.call(member, :id, :email, :username, :name, :username, :mobile, :university, :website_url, :talk_id, :talk_signature)

json.avatar_url member.avatar_url
json.auth_token member.generate_jwt
json.confirmed member.confirmed?
