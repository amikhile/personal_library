class CreateKmediaFile < ActiveRecord::Migration
  def change
    create_table :kmedia_files do |t|
      t.string :name
      t.date :date
      t.integer :kmedia_id
      t.string :url
      t.timestamps
    end
  end
end

