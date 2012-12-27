class InboxFile < ActiveRecord::Base

  has_and_belongs_to_many :filters, :join_table => "inbox_files_filters"
  has_and_belongs_to_many :labels

  scope :not_archived, InboxFile.where(:archived => false)
end