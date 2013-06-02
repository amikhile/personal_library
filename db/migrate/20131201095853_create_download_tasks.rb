class CreateDownloadTasks < ActiveRecord::Migration
  def change
    create_table :download_tasks do |t|
      t.belongs_to :user
      t.text :files
      t.datetime :ready
      t.string :zip_name
      t.string :status
      t.timestamps
    end
  end
end
