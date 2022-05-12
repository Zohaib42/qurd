module Api
  module V1
    class NotificationsController < SecureController
      def index
        @notifications = current_member.notifications.includes(:recipient, :notifier).order(created_at: :desc)
      end

      def read
        notification = Notification.find(params[:id])
        response = ReadNotificationInteractor.call(
          current_member: current_member,
          notification: notification
        )

        if response.success?
          render_okay response.notifications
        else
          render_unprocessable_entity(
            errors: response.errors,
            meta: { error_message: response.errors.full_messages.to_sentence }
          )
        end
      end
    end
  end
end
