class CreateFilterTemplateNames < ActiveRecord::Migration
  def change
    create_table :filter_template_names do |t|
      t.belongs_to :filter_template
      t.string :name
      t.string :code3
      t.timestamps
    end
  end
end
