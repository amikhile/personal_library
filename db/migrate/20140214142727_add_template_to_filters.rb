class AddTemplateToFilters < ActiveRecord::Migration
  def change
    add_column :filters, :template, :boolean, :default => false
  end
end
