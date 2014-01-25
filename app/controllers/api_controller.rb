class ApiController < ApplicationController
  skip_before_filter :check_logged_in, :authenticate_user!, :set_data


  def morning_lessons
    @morning_lessons = Rails.cache.fetch(:morning_lessons, expires_in: 5.minutes) do
      KmediaClient.get_files_from_morning_lessons
    end
  end
end