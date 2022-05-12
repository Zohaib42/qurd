class ReadNotificationInteractor
  include Interactor

  delegate :current_member, :notification, to: :context

  def call
    notifications.update_all(status: Notification::STATUSES[:read])

    context.notifications = notifications
  end

  private

  def notifications
    @notifications ||= begin
      klass = notification.notifiable_type.constantize

      klass.find(notification.notifiable_id).notifications.unread.where('recipient_id = ?', current_member.id)
    end
  end
end
