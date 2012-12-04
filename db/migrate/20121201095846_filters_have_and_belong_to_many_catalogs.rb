class FiltersHaveManyCatalogs < ActiveRecord::Migration
  create_table :filters_catalogs, :id => false do |t|
    t.references :filters, :catalogs
  end
end
