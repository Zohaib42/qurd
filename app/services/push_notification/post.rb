module PushNotification
  class Post < Base
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
        data: { recipient: recipient, notifier: notifier, object: object }.as_json
      }
    end

    def title
      "#{notifier.username} added a new #{object.class.name} - #{object.title}"
    end
  end
end
