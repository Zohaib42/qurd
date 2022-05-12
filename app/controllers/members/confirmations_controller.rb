module Members
  class ConfirmationsController < ::Devise::ConfirmationsController
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      path = if resource.errors.empty?
               set_flash_message!(:notice, :confirmed)
               confirm_notice_members_path(id: resource)
             else
               flash[:error] = resource.errors.full_messages.to_sentence
               confirm_notice_members_path
             end

      redirect_to path
    end
  end
end
