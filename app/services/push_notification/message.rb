module PushNotification
  class Message < Base
    def call
      notify do
        Rpush::Gcm::Notification.create!(notification_params)
      end
    end

    private

    def notification_params
      base_params.merge(data: data, notification: data)
    end

    def data
      {
        title: title,
        data: { recipient: recipient, notifier: notifier, object: object, message: meta[:message] }.as_json
      }
    end

    def title
      message = notifier.username
      message = "#{message} to #{object.name}" if object.channel?

      "#{message} - #{meta[:message].truncate(500)}"
    end
  end
end
