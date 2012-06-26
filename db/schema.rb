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

ActiveRecord::Schema.define(:version => 20120626033113) do

  create_table "ebert_data", :force => true do |t|
    t.float    "stars",      :default => 0.0
    t.integer  "movie_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "ebert_data", ["movie_id"], :name => "index_ebert_data_on_movie_id"

  create_table "hsx_data", :force => true do |t|
    t.float    "price",      :default => 0.0
    t.integer  "gross",      :default => 0
    t.integer  "theaters",   :default => 0
    t.integer  "movie_id",   :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "url",        :default => "",  :null => false
  end

  add_index "hsx_data", ["movie_id"], :name => "index_hsx_data_on_movie_id"

  create_table "imdb_data", :force => true do |t|
    t.text     "title"
    t.integer  "viewer",      :default => 0
    t.integer  "metacritic",  :default => 0
    t.integer  "movie_meter", :default => 0
    t.integer  "budget",      :default => 0
    t.integer  "movie_id",    :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "url",         :default => "", :null => false
  end

  add_index "imdb_data", ["movie_id"], :name => "index_imdb_data_on_movie_id"

  create_table "movies", :force => true do |t|
    t.string   "title",                         :null => false
    t.boolean  "default",    :default => false
    t.integer  "score",      :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "released",   :default => false
  end

  add_index "movies", ["default"], :name => "index_movies_on_default"
  add_index "movies", ["title"], :name => "index_movies_on_title", :unique => true

  create_table "rt_data", :force => true do |t|
    t.date     "release_date"
    t.integer  "runtime",           :default => 0
    t.string   "mpaa_rating"
    t.text     "critics_consensus"
    t.integer  "critics_score",     :default => 0
    t.integer  "audience_score",    :default => 0
    t.integer  "movie_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "rt_data", ["movie_id"], :name => "index_rt_data_on_movie_id"

  create_table "services", :force => true do |t|
    t.string   "name",                      :null => false
    t.integer  "status",     :default => 0
    t.integer  "strength",   :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "tweet_data", :force => true do |t|
    t.integer  "num",        :default => 0
    t.integer  "movie_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "tweet_data", ["movie_id"], :name => "index_tweet_data_on_movie_id"

end
