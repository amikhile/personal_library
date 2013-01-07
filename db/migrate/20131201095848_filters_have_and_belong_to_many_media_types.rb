class FiltersHaveAndBelongToManyMediaTypes < ActiveRecord::Migration
  def change
    create_table :filters_media_types, :id => false do |t|
      t.references :filter, :media_type
    end
  end
end
