module Api
  module V1
    class AccountsController < SecureController
      skip_load_and_authorize_resource
      skip_before_action :authenticate_member, :current_ability, only: %i[reset_password_link]

      def confirmation_status
        return render_okay if current_member.confirmed?

        render_unauthorized
      end

      def resend_confirmation
        current_member.resend_confirmation_notification

        render_okay current_member
      end

      def reset_password_link
        member = Member.find_by!(email: reset_password_params[:email])
        return render_okay if member.send_reset_password_instructions

        render_error errors: member.errors.full_messages.to_sentence
      end

      def change_password
        if current_member.update_with_password(change_password_params)
          render_okay(message: 'Password changed successfully.')
        else
          render_unprocessable_entity(
            errors: current_member.errors,
            meta: { error_message: current_member.errors.full_messages.to_sentence }
          )
        end
      end

      def suggestions
        @members = RetrieveSuggestedMembers.new(current_member).fetch_data
      end

      private

      def change_password_params
        params.require(:account).permit(:password, :password_confirmation, :current_password)
      end

      def reset_password_params
        params.require(:account).permit(:email)
      end
    end
  end
end
