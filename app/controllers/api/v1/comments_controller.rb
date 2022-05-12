module Api
  module V1
    class CommentsController < SecureController
      before_action :set_post, only: %i[index create destroy]
      before_action :set_comment, only: %i[destroy]

      def index
        @comments = @post.comments.includes(:author, :tagged_members)
      end

      def create
        result = CommentOrganizer.call(
          current_member: current_member,
          params: comment_params,
          post: @post
        )

        if result.success?
          @comment = result.comment
        else
          render_unprocessable_entity errors: result.errors, meta: result.meta
        end
      end

      def destroy
        if @comment.destroy
          render_okay(json_content: 'Successfully deleted comment.')
        else
          render_unprocessable_entity(
            errors: comment.errors,
            meta: { error_message: comment.errors.full_messages.to_sentence }
          )
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:content, tagged_member_ids: [])
      end

      def set_post
        @post = Post.find(params[:post_id])
      end

      def set_comment
        @comment = @post.comments.find(params[:id])
      end
    end
  end
end
