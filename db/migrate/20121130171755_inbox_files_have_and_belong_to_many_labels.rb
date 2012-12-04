class InboxFilesHaveAndBelongToManyLabels < ActiveRecord::Migration
  create_table :inbox_files_labels, :id => false do |t|
    t.references :inbox_file, :label
  end
end

