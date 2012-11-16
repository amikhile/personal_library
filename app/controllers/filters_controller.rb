class FiltersController < ApplicationController


  def index
    @filters = Filter.accessible_by(@current_user, :index)
  end

end