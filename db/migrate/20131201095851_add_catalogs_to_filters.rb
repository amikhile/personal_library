class AddCatalogsToFilters < ActiveRecord::Migration
  def change
      add_column :filters, :catalogs, :text
  end
end
