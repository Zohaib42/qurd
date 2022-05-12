json.groups @groups do |group|
  json.partial! 'group', group: group
end
