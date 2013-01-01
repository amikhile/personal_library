class CreateContentTypes < ActiveRecord::Migration
  def change
    create_table :content_types do |t|
      t.string :name
      t.integer :kmedia_id
      t.timestamps
    end
  end
end
