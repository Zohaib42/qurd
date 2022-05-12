module Api
  module V1
    class OnboardingsController < SecureController
      skip_load_and_authorize_resource

      def create
        authorize! :create, :onboardings

        result = OnboardingOrganizer.call(onboarding_params)

        if result.success?
          @member = result.member
        else
          render_unprocessable_entity errors: result.errors, meta: result.meta
        end
      end

      private

      def onboarding_params
        permitted_params = params.require(:onboarding).permit(member_attributes: [:pronouns, :star_sign, :website_url, :image], skills: [], interests: [])
        permitted_params[:member] = current_member
        permitted_params
      end
    end
  end
end
