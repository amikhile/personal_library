class Label < ActiveRecord::Base


  has_and_belongs_to_many :users



  scope :belong_to_current_user, where(:user => @current_user)
end
