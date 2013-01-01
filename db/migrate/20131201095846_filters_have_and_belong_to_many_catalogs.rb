class FiltersHaveAndBelongToManyCatalogs < ActiveRecord::Migration
  def change
    create_table :filters_catalogs, :id => false do |t|
      t.references :filters
      t.integer :kmedia_catalog_id
    end
  end
end
