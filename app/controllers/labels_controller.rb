class LabelsController < ApplicationController
  load_and_authorize_resource


  def index
    @labels = @labels.order(:id).page(params[:page])
  end

  def new
    @label = Label.new
    authorize! :new, @label
  end

  def create
    @label = Label.new
    authorize! :create, @label

    @label.attributes=params[:label]

    if @label.save
      redirect_to inbox_files_path, :notice => "Label Successfully created"
    end
  end

  def show
    begin
      @label = Label.find(params[:id])
      authorize! :show, @label
    rescue
      redirect_to labels_path, :alert => "There is no label with ID=#{params[:id]}."
      return
    end
  end

  def update
    @label = Label.find(params[:id])
    authorize! :update, @label

    @label.attributes = params[:label]
    if @label.save
      redirect_to label_path(@label), :notice => "label was Successfully updated"
    else
      render :action => 'edit'
    end
  end
end