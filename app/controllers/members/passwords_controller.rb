module Members
  class PasswordsController < ::Devise::PasswordsController
    layout 'devise', only: %i[edit]

    def update
      super
      flash.clear
    end

    protected

    def after_resetting_password_path_for(resource)
      password_change_success_member_path(resource)
    end
  end
end
