# frozen_string_literal: true

module Api
  module V1
    class DevicesController < SecureController
      def create
        device = current_member.devices.where(token: device_params[:token]).first_or_create(platform: device_params[:platform])

        if device.save
          render_okay device
        else
          render_unprocessable_entity errors: device.errors, meta: { error_message: device.errors.full_messages.to_sentence }
        end
      end

      private

      def device_params
        params.require(:device).permit(:token, :platform)
      end
    end
  end
end
