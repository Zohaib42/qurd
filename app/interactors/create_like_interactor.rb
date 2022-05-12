class CreateLikeInteractor
  include Interactor

  delegate :current_member, :post, to: :context

  def call
    if like.save
      NotificationManager.new(post.creator, current_member, post, NOTIFICATION_TYPES[:like]).call

      context.like = like
    else
      context.fail!(errors: like.errors, meta: { error_message: like.errors.full_messages.to_sentence })
    end
  end

  private

  def like
    @like ||= post.likes.find_or_initialize_by(member_id: current_member.id)
  end
end
