class CreateCommentInteractor
  include Interactor

  delegate :current_member, :post, :params, to: :context

  def call
    comment = post.comments.new(params)
    comment.author = current_member

    if comment.save
      NotificationManager.new(post.creator, current_member, post, NOTIFICATION_TYPES[:comment], { comment: comment }).call

      context.comment = comment
    else
      context.fail!(errors: comment.errors, meta: { error_message: comment.errors.full_messages.to_sentence })
    end
  end
end
