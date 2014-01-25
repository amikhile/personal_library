class ApiController < ApplicationController
  skip_before_filter :check_logged_in, :authenticate_user!, :set_data

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
end