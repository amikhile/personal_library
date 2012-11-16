class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.string :description
      t.integer :department_id
      t.timestamps
    end
  end
end
