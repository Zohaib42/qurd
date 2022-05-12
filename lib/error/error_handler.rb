require_relative 'helpers/render'

module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError do |e|
          respond(:standard_error, 500, e.to_s)
        end
        rescue_from ActiveRecord::RecordNotFound do |e|
          respond(:record_not_found, 404, e.to_s)
        end
        rescue_from CanCan::AccessDenied do |e|
          respond(:unauthorised, 401, e.message)
        end
      end
    end

    private

    def respond(error, status, message)
      json = Error::Helpers::Render.json(error, status, message)
      render status: status, json: json
    end
  end
end
