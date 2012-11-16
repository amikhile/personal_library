class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.text :text
      t.date :from_date
      t.date :to_date
      t.timestamps
    end
  end
end
