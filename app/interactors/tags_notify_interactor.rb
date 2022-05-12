class TagsNotifyInteractor
  include Interactor

  delegate :current_member, :post, :comment, to: :context

  def call
    return if comment.tagged_members.blank?

    comment.tagged_members.each do |member|
      NotificationManager.new(member, current_member, post, NOTIFICATION_TYPES[:comment_tag], { comment: comment }).call
    end
  end
end
