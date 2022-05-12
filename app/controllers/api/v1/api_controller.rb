module Api
  module V1
    class ApiController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods
      include Error::ErrorHandler
      include Respondable
      include ActionController::MimeResponds
      include ActionController::Flash
      include PaginationHandler
    end
  end
end
