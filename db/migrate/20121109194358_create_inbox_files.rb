class CreateInboxFiles < ActiveRecord::Migration
  def change
    create_table :inbox_files do |t|
       t.string :name
       t.integer :kmedia_id
       t.string :url
       t.text :description
      t.timestamps
    end
  end
end
