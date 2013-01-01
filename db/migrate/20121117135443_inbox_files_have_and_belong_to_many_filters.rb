class InboxFilesHaveAndBelongToManyFilters < ActiveRecord::Migration
  def change
    create_table :filters_inbox_files, :id => false do |t|
      t.references :inbox_file, :filter
    end
  end
end

