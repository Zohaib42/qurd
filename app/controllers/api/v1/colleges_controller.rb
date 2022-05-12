module Api
  module V1
    class CollegesController < SecureController
      def index
        @colleges = College.sort_by_members_count do
          CollegesWithMembersService.new(
            College.search(params[:term]).includes(:college_domains)
          ).call
        end
      end
    end
  end
end
