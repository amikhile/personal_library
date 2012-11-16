class UserHaveAndBelongToManyLabels < ActiveRecord::Migration
  create_table :labels_users, :id => false do |t|
    t.references :label, :user
  end
end
