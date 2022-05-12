class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied, with: :user_not_authorized

  PER_PAGE = 10

  def after_sign_in_path_for(resource)
    case resource
    when User
      admin_panel_root_path
    else
      super
    end
  end

  def after_accept_path_for(resource)
    case resource
    when User
      admin_panel_root_path
    else
      super
    end
  end

  private

  def user_not_authorized
    redirect_to (request.referer || root_path), status: :forbidden
  end

  def page
    params[:page].presence || 1
  end

  def per_page
    params[:per_page].presence || PER_PAGE
  end
end
