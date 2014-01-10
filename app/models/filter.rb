class Filter < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_many :inbox_files, :dependent => :destroy
  has_and_belongs_to_many :content_types
  has_and_belongs_to_many :media_types
  has_and_belongs_to_many :languages


  validates :name, :presence => true

  def to_s
    "Name:#{self.name} [Id:#{self.id}]"
  end
end
