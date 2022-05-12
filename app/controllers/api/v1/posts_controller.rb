module Api
  module V1
    class PostsController < SecureController
      before_action :set_post, only: %i[show]

      def index
        @meta, @posts, @shares = RetrievePostsService.new(params[:offset], current_member).fetch_data
      end

      def create
        @post = current_member.posts.new(post_params)

        if @post.save
          current_member.followers.each do |member|
            NotificationManager.new(member, current_member, @post, NOTIFICATION_TYPES[:post]).call
          end
        else
          render_unprocessable_entity(
            errors: @post.errors,
            meta: { error_message: @post.errors.full_messages.to_sentence }
          )
        end
      end

      def show; end

      def destroy
        @post = current_member.posts.find params[:id]

        if @post.destroy
          render_okay @post
        else
          render_unprocessable_entity(
            errors: @post.errors,
            meta: { error_message: @post.errors.full_messages.to_sentence }
          )
        end
      rescue StandardError => e
        Honeybadger.notify(e)
      end

      private

      def post_params
        params.require(:post).permit(:title, :post_type, :description, :attachment, :share_type, :link, :add_to_portfolio)
      end

      def set_post
        @post = Post.includes(:creator, comments: :author, likes: :member).find(params[:id])
      end
    end
  end
end
