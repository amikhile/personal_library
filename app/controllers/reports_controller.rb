class ReportsController < ApplicationController
  authorize_resource :class => false

  def show_user_logins
    @reports = []
    User.find_each do |user|
      logins = user.audits
      report = UserReport.new()
      report.user = user
      report.logins_count = user.sign_in_count
      report.login_last_week= user.audits.where("created_at >= ? AND audited_changes like ?", 1.week.ago, "%sign_in_count%").count
      report.login_last_month= user.audits.where("created_at >= ? AND audited_changes like ?", 1.month.ago, "%sign_in_count%").count
      @reports << report
    end
    if (params[:format]=='csv')
      send_data UserReport.reports_to_csv(@reports)
    else
      @reports
    end
  end

  def show_library_report
    @report = LibraryReport.new()
    @report.total_users = User.count

    # @t = user.audits.where("created_at >= ? AND action = ?", 1.year.ago, "create").group_by{|audit| audit.created_at.at_beginning_of_month}
    #e= User.where("created_at >= ?",1.year.ago).group_by { |u| u.created_at.beginning_of_month }
    @report.average_month_new_users= User.group("DATE_TRUNC('month', created_at)").count
    @report
  end

end