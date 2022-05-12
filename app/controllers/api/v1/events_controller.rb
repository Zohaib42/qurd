module Api
  module V1
    class EventsController < SecureController
      before_action :set_event, only: %i[show]

      def index
        events = Event.where('DATE(start_at) >= ?', Time.zone.now.to_date).includes(:members).order(start_at: :asc).with_attached_cover
        @meta, @events = paginate events
      end

      def show; end

      private

      def set_event
        @event = Event.find(params[:id])
      end
    end
  end
end
