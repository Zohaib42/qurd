json.member do |json|
  json.partial! 'api/v1/members/member', member: @current_member
end
