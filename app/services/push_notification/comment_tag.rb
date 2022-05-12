module PushNotification
  class CommentTag < Base
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
      "#{notifier.username} tagged you in a comment - #{comment} - #{object.title}"
    end

    def comment
      meta[:comment].content.split(' ').collect do |word|
        escape(word)
      end.join(' ')
    end

    def escape(word)
      return word unless word.start_with? '@'

      "@#{word.gsub(/[^a-zA-Z\-]/, '')}"
    end
  end
end
