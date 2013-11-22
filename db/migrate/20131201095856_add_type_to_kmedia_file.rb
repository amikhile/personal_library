class AddTypeToKmediaFile < ActiveRecord::Migration
  def change
    add_column :kmedia_files, :ext, :string
  end
end
