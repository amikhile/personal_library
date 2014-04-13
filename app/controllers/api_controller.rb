class ApiController < ApplicationController
  skip_before_filter :check_logged_in, :authenticate_user!, :set_data, :set_locale, :load_filters_and_labels

  #GET http://mylibrary.kbb1.com/api/morning_lessons.json?lang=ENG
  def morning_lessons
    lang = params[:lang]
    @morning_lessons = Rails.cache.fetch(:morning_lessons, expires_in: 5.minutes) do
      KmediaClient.get_files_from_morning_lessons
    end
    if(lang)
      @morning_lessons =  @morning_lessons.select{|l| l["lang"] == lang }
    end
  end

  #GET http://mylibrary.kbb1.com/api/my_files.json?page=5&per_page=20&usr=annamik&pwd=123456&updated_from=1395910531&for=mobile
  def my_files
    @errors=[]

    username = params[:usr]
    @user = User.find_by_username(username)
    @errors << "User #{username} not found." unless @user.present?
    @errors << "Mandatory parameter 'for' is missing." unless params[:for].present?
    return if  @errors.any?

    page = params[:page] || 1
    @per_page = params[:per_page] || 20
    #TODO ask about not_archived
    filters = @user.filters
    filters = filters.mobile if 'mobile'== params[:for]
    filters = filters.pc if 'pc'== params[:for]
    filters = filters.order(:id).pluck(:id) rescue []


    #Client.where("created_at >= :start_date AND created_at <= :end_date",
    #{:start_date => params[:start_date], :end_date => params[:end_date]})
    updated_from=  Time.at(params[:updated_from].to_i).to_datetime if params[:updated_from].present? rescue nil
    @inbox_files = InboxFile.where("filter_id" => filters)
    @inbox_files = @inbox_files.where("updated_at > :updated",{updated:  updated_from}) if updated_from.present?
    @inbox_files = @inbox_files.order(:id).page(page).per(@per_page)


  end
end