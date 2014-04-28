class ReportsController < ApplicationController
  authorize_resource :class => false

  def show_user_logins
    @reports = []
    User.find_each do |user|
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
      sort
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

  private
  #%th= sortable("username", t('ui.report.username'))
  #%th= sortable("email", t('ui.report.email'))
  #%th= sortable("registered", t('ui.report.registered'))
  #%th= sortable("last_week", t('ui.report.last_week'))
  #%th= sortable("last_month", t('ui.report.last_month'))
  #%th= sortable("total_logins", t('ui.report.total_logins'))
  def sort
      if (sort_column == 'username')
        @reports = @reports.sort_by{|report| report.user.username} if sort_direction=='asc'
        @reports = @reports.sort_by{|report| report.user.username}.reverse if sort_direction=='desc'
      elsif (sort_column == 'email')
        @reports = @reports.sort_by{|report| report.user.email} if sort_direction=='asc'
        @reports = @reports.sort_by{|report| report.user.email}.reverse if sort_direction=='desc'
      elsif (sort_column == 'registered')
        @reports = @reports.sort_by{|report| report.user.created_at.to_date} if sort_direction=='asc'
        @reports = @reports.sort_by{|report| report.user.created_at.to_date}.reverse if sort_direction=='desc'
      elsif (sort_column == 'last_week')
        @reports = @reports.sort_by{|report| report.login_last_week} if sort_direction=='asc'
        @reports = @reports.sort_by{|report| report.login_last_week}.reverse if sort_direction=='desc'
      elsif (sort_column == 'last_month')
        @reports = @reports.sort_by{|report| report.login_last_month} if sort_direction=='asc'
        @reports = @reports.sort_by{|report| report.login_last_month}.reverse if sort_direction=='desc'
      elsif (sort_column == 'total_logins')
        @reports = @reports.sort_by{|report| report.logins_count} if sort_direction=='asc'
        @reports = @reports.sort_by{|report| report.logins_count}.reverse if sort_direction=='desc'
      end
  end




end