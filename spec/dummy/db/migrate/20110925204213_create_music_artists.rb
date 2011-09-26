class CreateMusicArtists < ActiveRecord::Migration
  def up
    create_table :music_artists do |t| 
      t.string :name
      t.text :tag_list
      t.integer :author_id
      t.string :state
      t.timestamps
    end  
  end

  def down
    drop_table :music_artists
  end
end
