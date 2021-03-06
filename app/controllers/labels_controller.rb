class LabelsController < ApplicationController
  load_and_authorize_resource

  def index
    @labels = current_user.labels.order(:id).page(params[:page])
  end

  def new
    @label = Label.new
    authorize! :new, @label
  end

  def create
    @label = Label.new
    authorize! :create, @label

    @label.attributes=params[:label]
    @label.users << current_user
    if @label.save
      redirect_to labels_path, :notice => "Label Successfully created"
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
    @label.users << current_user unless @label.users.include? current_user
    if @label.save
      redirect_to label_path(@label), :notice => "Label was Successfully updated"
    else
      render :action => 'edit'
    end
  end

  def export
    authorize! :index, Filter
    label = Label.find(params[:id])
    inbox_files = InboxFile.joins(:labels).where("labels.id" => label.id)
    files = KmediaFile.where("id in (?)",inbox_files.collect(&:kmedia_file_id)).multipluck(:name, :url) rescue []
    export_to_file(files, label.name)

  end

  def destroy
    @label = Label.find(params[:id])
    authorize! :destroy, @label
    @label.destroy
    redirect_to labels_url, :notice => "Label deleted successfully."
  end

end