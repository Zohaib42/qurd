# frozen_string_literal: true

class NotificationManager
  attr_reader :recipient, :notifier, :object, :meta, :notification_type

  def initialize(recipient, notifier, object, notification_type, meta = {})
    @recipient = recipient
    @notifier = notifier
    @object = object
    @meta = meta
    @notification_type = notification_type
  end

  def call
    klass = "PushNotification::#{notification_type.classify}".constantize

    klass.call(recipient, notifier, object, meta)
  end
end
