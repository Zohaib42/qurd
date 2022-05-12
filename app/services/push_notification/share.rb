module PushNotification
  class Share < Base
    def call
      notify do
        Rpush::Gcm::Notification.create!(notification_params)
      end
    end

    def notification_params
      base_params.merge(data: data, notification: data)
    end

    def data
      {
        title: title,
        data: { recipient: recipient, notifier: notifier, object: object }.as_json
      }
    end

    def title
      "#{notifier.username} echoed your #{object.class.name}"
    end
  end
end
