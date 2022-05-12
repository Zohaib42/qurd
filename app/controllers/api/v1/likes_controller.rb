module Api
  module V1
    class LikesController < SecureController
      before_action :set_post, only: %i[create destroy]
      before_action :set_like, only: %i[destroy]

      def create
        result = CreateLikeInteractor.call current_member: current_member, post: @post

        if result.success?
          @like = result.like
        else
          render_unprocessable_entity errors: result.errors, meta: result.meta
        end
      end

      def destroy
        return render_okay if @like.blank?

        render_unprocessable_entity(errors: @like.errors, meta: { error_message: @like.errors.full_messages.to_sentence }) unless @like.destroy
      end

      private

      def set_post
        @post = Post.find(params[:post_id])
      end

      def set_like
        @like = @post.likes.find_by!(member_id: current_member.id)
      end
    end
  end
end
