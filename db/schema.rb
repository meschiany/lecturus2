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

ActiveRecord::Schema.define(:version => 20160326144821) do

  create_table "colleges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "courses", :force => true do |t|
    t.integer  "college_id"
    t.string   "name"
    t.string   "professor"
    t.integer  "year"
    t.integer  "semester"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "video_id"
    t.integer  "second"
    t.integer  "user_id"
    t.integer  "type"
    t.boolean  "active"
    t.text     "text"
    t.string   "f_type"
    t.string   "f_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "f_name"
    t.string   "l_name"
    t.integer  "college_id"
    t.string   "password"
    t.datetime "last_login_timestamp"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.integer  "master_id"
    t.datetime "start_record_timestamp"
    t.datetime "end_record_timestamp"
    t.integer  "course_id"
    t.decimal  "length"
    t.string   "status"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

end
