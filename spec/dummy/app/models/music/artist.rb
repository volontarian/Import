class Music::Artist < ActiveRecord::Base  
  set_table_name 'music_artists'
  
  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  
  attr_accessible :name, :tag_list, :author_id
  
  # TODO: Move to Import::NoRelation
  def self.find_existing_entries(criteria, values)
    class_eval <<-EOV
find_by_sql(
  [
    "SELECT music_artists.id AS id, music_artists.name AS name FROM music_artists WHERE #{criteria}",
    "#{values.join('", "')}"
  ]
).map{|a| [a.id, a.name]}
EOV
  end  
end