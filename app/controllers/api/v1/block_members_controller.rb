module Api
  module V1
    class BlockMembersController < SecureController
      before_action :set_block_member, only: %i[destroy]

      def create
        block_member = current_member.block_members.where(member_id: block_member_params[:member_id]).first_or_initialize

        if block_member.save
          render_okay block_member
        else
          render_unprocessable_entity(
            errors: block_member.errors,
            meta: { error_message: block_member.errors.full_messages.to_sentence }
          )
        end
      end

      def destroy
        if @block_member.destroy
          render_okay @block_member
        else
          render_unprocessable_entity(
            errors: @block_member.errors,
            meta: { error_message: @block_member.errors.full_messages.to_sentence }
          )
        end
      end

      private

      def block_member_params
        params.require(:block_member).permit(:member_id)
      end

      def set_block_member
        @block_member = current_member.block_members.find_by! member_id: params[:block_member_id]
      end
    end
  end
end
