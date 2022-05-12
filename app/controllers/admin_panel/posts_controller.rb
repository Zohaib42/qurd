module AdminPanel
  class PostsController < BaseController
    def destroy
      @post = Post.find(params[:id])

      if @post.destroy
        flash[:notice] = 'Post is successfully deleted.'
      else
        flash[:alert] = @post.errors.full_messages.to_sentence
      end

      redirect_to admin_panel_reports_path
    end
  end
end
