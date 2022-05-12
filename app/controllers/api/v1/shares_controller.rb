module Api
  module V1
    class SharesController < SecureController
      before_action :set_post, only: %i[create destroy]
      before_action :set_share, only: %i[destroy]

      def create
        share = current_member.shares.find_or_initialize_by(post_id: @post.id)

        if share.save
          NotificationManager.new(share.post.creator, current_member, share.post, NOTIFICATION_TYPES[:share]).call

          render_okay({ message: 'Successfully shared the post' })
        else
          render_unprocessable_entity(
            errors: share.errors,
            meta: { error_message: share.errors.full_messages.to_sentence }
          )
        end
      end

      def destroy
        if @share.destroy
          render_okay({ message: 'Successfully Undone the Share.' })
        else
          render_unprocessable_entity(
            errors: @share.errors,
            meta: { error_message: @share.errors.full_messages.to_sentence }
          )
        end
      end

      private

      def set_post
        @post = Post.find(params[:post_id])
      end

      def set_share
        @share = @post.shares.find_by!(member_id: current_member.id)
      end
    end
  end
end
