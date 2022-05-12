json.events @events do |event|
  json.partial! 'event', event: event
end

json.meta @meta.meta
