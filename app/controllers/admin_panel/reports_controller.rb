module AdminPanel
  class ReportsController < BaseController
    def index
      @post_reports = PostReport.open.includes(:reporter, post: [:creator]).page(params[:post_report_page]).per(per_page)
      @member_reports = MemberReport.open.includes(:reporter, :reported).page(page).per(per_page)
    end

    def post_report
      @post_report = PostReport.find params[:id]
    end

    def close_reports
      klass = "#{params[:klass]}Report".constantize
      @report = klass.find params[:id]

      if @report.update_column(:status, klass::STATUSES[:close])
        flash[:notice] = "#{params[:klass]} Report is successfully closed."
      else
        flash[:alert] = @report.errors.full_messages.to_sentence
      end

      redirect_to admin_panel_reports_path
    end

    def member_report
      @member_report = MemberReport.find params[:id]
    end
  end
end
