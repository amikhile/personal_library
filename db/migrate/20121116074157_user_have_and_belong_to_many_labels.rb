class UserHaveAndBelongToManyLabels < ActiveRecord::Migration
  def change
    create_table :labels_users, :id => false do |t|
      t.references :label, :user
    end
  end
end
