module Api
  module V1
    class GroupsController < SecureController
      before_action :set_group, only: %i[update destroy]
      before_action :set_participant_group, only: %i[show leave_group read_conversation]

      def index
        @groups = current_member.groups.includes(:members).order(updated_at: :desc)
      end

      def create
        response = CreateGroupInteractor.call(current_member: current_member, params: group_params)

        if response.success?
          render_okay response.group
        else
          render_unprocessable_entity(errors: response.errors, meta: response.meta)
        end
      end

      def show; end

      def update
        response = UpdateGroupInteractor.call(group: @group, params: group_params)

        if response.success?
          render_okay response.group
        else
          render_unprocessable_entity(
            errors: response.errors,
            meta: { error_message: response.errors.full_messages.to_sentence }
          )
        end
      end

      def destroy
        if @group.destroy
          render_okay
        else
          render_unprocessable_entity(
            errors: @group.errors,
            meta: { error_message: @group.errors.full_messages.to_sentence }
          )
        end
      end

      def leave_group
        response = LeaveGroupInteractor.call(
          group: @group,
          params: leave_group_params
        )

        if response.success?
          render_okay(json_content: 'Group left')
        else
          render_unprocessable_entity(errors: response.errors, meta: response.meta)
        end
      end

      def read_conversation
        member = Member.find params[:member_id]
        response = TalkJs::ReadGroupConversation.call(@group, member)

        if response.valid?
          render_okay
        else
          json_response = response.data.parsed_response

          render_unprocessable_entity errors: json_response, meta: { error_message: json_response['errorCode'] }
        end
      end

      private

      def group_params
        params.require(:group).permit(:name, :image, :chat_type, member_ids: [])
      end

      def set_group
        @group = current_member.created_groups.find(params[:id])
      end

      def set_participant_group
        @group = current_member.groups.find(params[:id])
      end

      def leave_group_params
        params.require(:leave_group).permit(:member_id)
      end
    end
  end
end
