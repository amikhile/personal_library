class UserReport
  require 'csv'
  attr_accessor :user, :login_last_week, :login_last_month, :logins_count

  def  self.reports_to_csv (reports)

    CSV.generate do |csv|
      column_names = ['Username','Email','Registered at','Login_last_week','Login_last_month','Total logins']
      csv << column_names
      reports.each do |report|
        csv << ["#{report.user.username}","#{report.user.email}","#{report.user.created_at.to_date}","#{report.logins_count}","#{report.login_last_week}","#{report.login_last_month}"]
      end

    end

  end
end