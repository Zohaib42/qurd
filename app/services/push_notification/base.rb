module PushNotification
  class Base
    attr_reader :recipient, :notifier, :object, :meta

    HIGH = 'high'.freeze

    def self.call(*args, &block)
      new(*args, &block).call
    end

    def initialize(recipient, notifier, object, meta = {})
      @recipient = recipient
      @notifier = notifier
      @object = object
      @meta = meta
    end

    def notify
      Rails.logger.tagged('PUSH_NOTIFICATION_FCM') {
        Rails.logger.debug("recipient: #{recipient.id}, notifier: #{notifier.id}, object: #{object.id}, type: #{object.class}")
      }

      if object.respond_to?(:notifications) && recipient.id != notifier.id
        object.notifications.create(title: title, recipient_id: recipient.id, notifier_id: notifier.id)
      end

      return if recipient.device_tokens.blank? || recipient.id == notifier.id

      yield

      PushNotificationJob.perform_later
    end

    def base_params
      {
        app: quadio_app,
        registration_ids: recipient.device_tokens,
        priority: HIGH,
        content_available: true
      }
    end

    private

    def quadio_app
      @quadio_app ||= Rpush::Gcm::App.find_by_name(QUADIO_APP)
    end
  end
end
