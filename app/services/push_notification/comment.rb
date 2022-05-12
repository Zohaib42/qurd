module PushNotification
  class Comment < Base
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
        data: { recipient: recipient, notifier: notifier, object: object, comment: meta[:comment] }.as_json
      }
    end

    def title
      "#{notifier.username} commented on your #{object.class.name}"
    end
  end
end
