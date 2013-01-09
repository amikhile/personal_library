class Filter < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_and_belongs_to_many :inbox_files
  has_and_belongs_to_many :content_types
  has_and_belongs_to_many :media_types
  has_and_belongs_to_many :languages
 # scope :belong_to_current_user, lambda{|user_id| joins(:users).where("users.id" => user_id)}
end
