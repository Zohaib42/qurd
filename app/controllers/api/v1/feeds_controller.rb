module Api
  module V1
    class FeedsController < SecureController
      skip_load_and_authorize_resource

      def index
        authorize! :index, :feeds

        @posts = Post.hottest_posts(current_member)
        @video_posts = Post.hottest_posts('video', current_member)
        @image_posts = Post.hottest_posts('image', current_member)
        @text_posts = Post.hottest_posts('text', current_member)
        @audio_post = Post.hottest_posts('audio', current_member)
        @skills = Skill.all
        @suggested_members = RetrieveSuggestedMembers.new(current_member).fetch_data
      end
    end
  end
end
