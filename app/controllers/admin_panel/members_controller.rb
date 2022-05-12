module AdminPanel
  class MembersController < BaseController
    before_action :set_member, only: %i[show destroy]

    def index
      @members = FilterMembersQuery.new(Member).call(params)
      @members = @members.page(page).per(per_page)
    end

    def show; end

    def destroy
      if @member.destroy
        flash[:notice] = 'Member deleted successfully.'
      else
        flash[:alert]  = @member.errors.full_messages.to_sentence
      end

      redirect_to admin_panel_members_path
    end

    private

    def set_member
      @member = Member.find params[:id]
    end
  end
end
