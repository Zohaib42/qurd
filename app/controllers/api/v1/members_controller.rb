module Api
  module V1
    class MembersController < SecureController
      def index
        records = FilterMembersQuery.new(Member, current_member).call(params).includes(:skills)
        @pagy, @members = paginate records
      end

      def follow
        result = FollowMemberInteractor.call(current_member: current_member, followed_id: params[:member_id])

        if result.success?
          render_okay({ message: 'Successfully followed member.' })
        else
          render_unprocessable_entity errors: result.errors, meta: result.meta
        end
      end

      def unfollow
        active_relationship = current_member.active_relationships.find_by!(followed_id: params[:member_id])

        if active_relationship.destroy
          render_okay(json_content: 'Unfollow member Successfully.')
        else
          render_unprocessable_entity(
            errors: active_relationship.errors,
            meta: { error_message: active_relationship.errors.full_messages.to_sentence }
          )
        end
      end

      def bulk_follow
        response = FollowMembersInteractor.call(
          current_member: current_member,
          member_ids: bulk_follow_params[:member_ids]
        )

        if response.success?
          render_okay json_content: 'Followed members successfully.'
        else
          render_unprocessable_entity(
            errors: response.errors,
            meta: { error_message: response.errors }
          )
        end
      end

      def followers_list
        records = FilterMembersQuery.new(
          Member.where('id IN (?)',
            (current_member.follower_ids + current_member.following_ids) - current_member.blocked_members_ids).distinct,
            current_member
        ).call(params)

        @pagy, @members = paginate records
      end

      def profile
        render_unprocessable_entity(
          errors: "This member is blocked",
          meta: { error_message: "blocked member" }
        ) and return if current_member.blocked_members_ids.include?(params[:id].to_i)

        @member = Member.find(params[:id])
        @posts_count = @member.posts.count
        @following_count = @member.following.count
        @followers_count = @member.followers.count
        @portfolio_posts = @member.posts.where(add_to_portfolio: true)
        @meta, @posts = RetrieveProfilePostsService.new(params[:offset], @member).fetch_data
      end

      def logout
        current_member.devices.destroy_all

        head :ok
      end

      private

      def bulk_follow_params
        params.require(:bulk_follow).permit(member_ids: [])
      end
    end
  end
end
