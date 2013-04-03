class InboxFile < ActiveRecord::Base

  belongs_to :filters
  has_and_belongs_to_many :labels
  belongs_to :kmedia_file

  accepts_nested_attributes_for :kmedia_file

  scope :not_archived, InboxFile.where(:archived => false)
end