class InboxFilesHaveAndBelongToManyFilters < ActiveRecord::Migration
  create_table :inbox_files_filters, :id => false do |t|
    t.references :inbox_file, :filter
  end
end

