# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110925204213) do

  create_table "imports", :force => true do |t|
    t.string   "type"
    t.text     "input"
    t.text     "parameters"
    t.string   "email"
    t.integer  "author_id"
    t.string   "parent_type"
    t.integer  "parent_id"
    t.text     "exception"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imports", ["author_id"], :name => "index_imports_on_author_id"
  add_index "imports", ["parent_type", "parent_id"], :name => "index_imports_on_parent_type_and_parent_id"
  add_index "imports", ["state"], :name => "index_imports_on_state"
  add_index "imports", ["type"], :name => "index_imports_on_type"

  create_table "music_artists", :force => true do |t|
    t.string   "name"
    t.text     "tag_list"
    t.integer  "author_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
