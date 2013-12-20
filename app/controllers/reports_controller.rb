class ReportsController < ApplicationController
 authorize_resource :class => false

  def show_user_logins
    #Audited::Adapters::ActiveRecord::Audit.where(:auditable_type => 'User)
    @reports = []
    User.find_each do |user|
      logins = user.audits
      report = UserReport.new()
      report.user = user
      report.logins_count = user.sign_in_count
      # "created_at >= ?", Date.today
      #, :action => 'update').count    Topic.where("name like ?", "%#{@search}%")
      #a =  user.audits.where("created_at >= ?", 1.week.ago).audited_changes
      report.login_last_week= user.audits.where("created_at >= ? AND audited_changes like ?", 1.week.ago,"%sign_in_count%").count
      report.login_last_month= user.audits.where("created_at >= ? AND audited_changes like ?", 1.month.ago,"%sign_in_count%").count
      @reports << report
    end
    if(params[:format]=='csv')
      send_data UserReport.reports_to_csv(@reports)
    else
     @reports
    end
  end
end