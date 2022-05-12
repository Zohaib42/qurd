module Api
  module V1
    class MemberReportsController < SecureController
      before_action :set_member_report, only: %i[destroy]

      def create
        member_report = current_member.member_reports.where(reported_id: member_report_params[:reported_id]).first_or_initialize
        member_report.assign_attributes(reason: member_report_params[:reason])

        if member_report.save
          render_okay member_report
        else
          render_unprocessable_entity(
            errors: member_report.errors,
            meta: { error_message: member_report.errors.full_messages.to_sentence }
          )
        end
      end

      def destroy
        if @member_report.destroy
          render_okay @member_report
        else
          render_unprocessable_entity(
            errors: @member_report.errors,
            meta: { error_message: @member_report.errors.full_messages.to_sentence }
          )
        end
      end

      private

      def member_report_params
        params.require(:member_report).permit(:reason, :reported_id)
      end

      def set_member_report
        @member_report = current_member.member_reports.find_by! reported_id: params[:member_report_id]
      end
    end
  end
end
