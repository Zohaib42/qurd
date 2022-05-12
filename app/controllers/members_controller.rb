class MembersController < ApplicationController
  layout 'without_sidebar', only: %i[password_change_success confirm_notice]

  def confirm_notice
    @member = Member.find_by id: params[:id]
  end

  def password_change_success; end
end
