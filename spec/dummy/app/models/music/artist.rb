class Music::Artist < ActiveRecord::Base  
  set_table_name 'music_artists'
  
  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  
  attr_accessible :name, :tag_list, :author_id
end