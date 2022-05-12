module Error
  module Helpers
    class Render
      def self.json(error, status, message)
        { status: status, errors: { title: [error] }, meta: { error_message: message } }.as_json
      end
    end
  end
end
