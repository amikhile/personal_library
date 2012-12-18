class Filter < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_and_belongs_to_many :inbox_files, :join_table => "inbox_files_filters"

 # scope :belong_to_current_user, lambda{|user_id| joins(:users).where("users.id" => user_id)}
end
