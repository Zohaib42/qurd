module AdminPanel
  class BaseController < ApplicationController
    before_action :reports_count

    def reports_count
      @reports_count = MemberReport.open.count + PostReport.open.count
    end
  end
end
