class CreateMediaTypes < ActiveRecord::Migration
  def change
    create_table :media_types do |t|
      t.string :name
      t.string :kmedia_id
      t.timestamps
    end
  end
end
