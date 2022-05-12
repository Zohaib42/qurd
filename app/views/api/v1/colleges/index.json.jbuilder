json.colleges @colleges do |college|
  json.partial! 'college', college: college
end
