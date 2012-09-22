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

ActiveRecord::Schema.define(:version => 20120922084159) do

  create_table "repos", :force => true do |t|
    t.string   "name"
    t.string   "owner"
    t.text     "language"
    t.integer  "forks"
    t.integer  "issues"
    t.integer  "watchers"
    t.string   "description"
    t.string   "last_commit_sha"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "location"
    t.string   "email"
    t.string   "type"
    t.string   "blog"
    t.string   "avatar_url"
    t.string   "company"
    t.text     "repos"
    t.integer  "following"
    t.integer  "followers"
    t.integer  "public_repos"
    t.integer  "public_gists"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
  end

end
