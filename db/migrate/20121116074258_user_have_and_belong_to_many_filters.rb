class UserHaveAndBelongToManyFilters < ActiveRecord::Migration
  def change
    create_table :filters_users, :id => false do |t|
      t.references :filter, :user
    end
  end
end
