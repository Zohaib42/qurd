module Api
  module V1
    class RsvpsController < SecureController
      before_action :set_rsvp, only: %i[destroy]

      def create
        rsvp = current_member.rsvps.where(event_id: rsvp_params[:event_id]).first_or_initialize

        if rsvp.save
          render_okay rsvp
        else
          render_unprocessable_entity(
            errors: rsvp.errors,
            meta: { error_message: rsvp.errors.full_messages.to_sentence }
          )
        end
      end

      def destroy
        if @rsvp.destroy
          render_okay @rsvp
        else
          render_unprocessable_entity(
            errors: @rsvp.errors,
            meta: { error_message: @rsvp.errors.full_messages.to_sentence }
          )
        end
      end

      private

      def rsvp_params
        params.require(:rsvp).permit(:event_id)
      end

      def set_rsvp
        @rsvp = current_member.rsvps.find_by! event_id: params[:event_id]
      end
    end
  end
end
