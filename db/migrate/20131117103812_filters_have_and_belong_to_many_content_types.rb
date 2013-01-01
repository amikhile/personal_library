class FiltersHaveAndBelongToManyContentTypes < ActiveRecord::Migration
  def change
    create_table :content_types_filters, :id => false do |t|
      t.references :filter, :content_type
    end
  end
end
