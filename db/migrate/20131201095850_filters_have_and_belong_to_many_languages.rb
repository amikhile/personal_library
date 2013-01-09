class FiltersHaveAndBelongToManyLanguages < ActiveRecord::Migration
  def change
    create_table :filters_languages, :id => false do |t|
      t.references :filter, :language
    end
  end
end
