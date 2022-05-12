module ReportHelper
  def active_report_tab?(current_tab, back_to, tab_type)
    klasses = {
      'link' => 'active',
      'tab' => 'show active'
    }
    return klasses[tab_type] if current_tab == back_to
    return klasses[tab_type] if back_to.blank? && current_tab == 'post_reports_tab'
  end
end
