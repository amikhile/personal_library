
class CreateInboxFiles < ActiveRecord::Migration
  def change
    create_table :inbox_files do |t|
       t.belongs_to :kmedia_file
       t.text :description
       t.boolean :archived, :default => false
       t.timestamps
    end
  end
end
