module Api
  module V1
    module Devise
      class SessionsController < ::Devise::SessionsController
        respond_to :json

        def create
          member = Member.find_by_email(sign_in_params[:email].downcase)

          if member&.valid_password?(sign_in_params[:password])
            @current_member = member
          else
            render json: { errors: I18n.t('member.login.failure.invalid') }, status: :unprocessable_entity
          end
        end

        private

        def sign_in_params
          params.require(:sign_in).permit(%i[email password])
        end
      end
    end
  end
end
