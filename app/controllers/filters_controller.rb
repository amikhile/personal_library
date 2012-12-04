class FiltersController < ApplicationController
  load_and_authorize_resource

  def index
    @filters = @filters.order(:id).page(params[:page])
  end

  def new
    @filter = Filter.new
    authorize! :new, @filter
  end

  def create
    @filter = Filter.new
    authorize! :create, @filter

    @filter.attributes=params[:lesson]

    if @filter.save
      redirect_to inbox_files_path, :notice => "Filter Successfully created"
    end
  end

  def show
    begin
      @filter = Filter.find(params[:id])
      authorize! :show, @filter
    rescue
      redirect_to filters_path, :alert => "There is no Filter with ID=#{params[:id]}."
      return
    end
  end

  def update
    @filter = Filter.find(params[:id])
    authorize! :update, @filter

    @filter.attributes = params[:lesson]
    if @filter.save
      redirect_to filter_path(@filter), :notice => "Filter was Successfully updated"
    else
      render :action => 'edit'
    end
  end
end