class CreateFilterTemplates < ActiveRecord::Migration
  def change
    create_table :filter_templates do |t|
      t.text :text
      t.date :from_date
      t.date :to_date
      t.text :catalogs
      t.timestamps
    end

    create_table :content_types_filter_templates, :id => false do |t|
      t.references :filter_template, :content_type
    end

    create_table :filter_templates_media_types, :id => false do |t|
      t.references :filter_template, :media_type
    end

    create_table :filter_templates_languages, :id => false do |t|
      t.references :filter_template, :language
    end
  end
end
