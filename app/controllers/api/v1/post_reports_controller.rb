module Api
  module V1
    class PostReportsController < SecureController
      before_action :set_post_report, only: %i[destroy]

      def create
        post_report = current_member.post_reports.where(post_id: post_report_params[:post_id]).first_or_initialize
        post_report.assign_attributes(reason: post_report_params[:reason])

        if post_report.save
          render_okay post_report
        else
          render_unprocessable_entity(
            errors: post_report.errors,
            meta: { error_message:  post_report.errors.full_messages.to_sentence }
          )
        end
      end

      def destroy
        if @post_report.destroy
          render_okay @post_report
        else
          render_unprocessable_entity(
            errors: @post_report.errors,
            meta: { error_message: @post_report.errors.full_messages.to_sentence }
          )
        end
      end

      private

      def post_report_params
        params.require(:post_report).permit(:reason, :post_id)
      end

      def set_post_report
        @post_report = current_member.post_reports.find_by! post_id: params[:post_report_id]
      end
    end
  end
end
