class ExportRsvp
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def call
    CSV.generate do |csv|
      csv << column_names

      event.rsvps.find_each do |rsvp|
        csv << rsvp.member.attributes.values_at(*column_names)
      end
    end
  end

  private

  def column_names
    %w[email]
  end
end
