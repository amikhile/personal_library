class AddDownloadOptionsToFilters < ActiveRecord::Migration
  def change
    add_column :filters, :download_mobile, :boolean, default: false
    add_column :filters, :download_pc, :boolean, default: false
  end
end
