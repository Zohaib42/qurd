module AdminPanel
  class EventsController < BaseController
    before_action :set_event, only: %i[edit update destroy]

    def index
      @upcoming_events =
        Event.where('DATE(start_at) >= ?', Time.zone.now.to_date).order(start_at: :asc).page(params[:upcoming_events_page]).per(per_page)

      @historical_events =
        Event.where('DATE(start_at) < ?', Time.zone.now.to_date).order(start_at: :asc).page(params[:historical_events_page]).per(per_page)
    end

    def new
      @event = Event.new

      respond_to do |format|
        format.js
      end
    end

    def create
      @event = Event.new event_params

      respond_to do |format|
        format.js
      end
    end

    def edit; end

    def update
      @event.update(event_params)

      respond_to do |format|
        format.js
      end
    end

    def destroy
      respond_to do |format|
        format.js
      end
    end

    def export_rsvp
      @event = Event.includes(rsvps: :member).find params[:id]

      send_data ExportRsvp.new(@event).call, filename: 'rsvps.csv'
    end

    private

    def set_event
      @event = Event.find params[:id]
    end

    def event_params
      params.require(:event).permit(:title, :description, :price, :location, :start_at, :end_at, :cover)
    end
  end
end
