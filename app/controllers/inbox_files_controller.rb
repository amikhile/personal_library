class InboxFilesController < ApplicationController
  load_and_authorize_resource

  def index
    @files = InboxFile.order(:id).page(params[:page])
  end

end