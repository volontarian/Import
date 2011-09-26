class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t| 
      t.string :type
      t.text :input
      t.text :parameters
      t.string :email
      t.integer :author_id
      t.string :parent_type
      t.integer :parent_id
      t.text :exception
      t.string :state
      t.timestamps
    end  

    change_table :imports do |t|
      t.index :type
      t.index :author_id
      t.index [:parent_type, :parent_id]
      t.index :state
    end
  end

  def self.down
    drop_table :imports
  end
end