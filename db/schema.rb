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

ActiveRecord::Schema.define(:version => 20121013070914) do

  create_table "matches", :force => true do |t|
    t.integer  "round_id",                          :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.datetime "matchdate"
    t.string   "match_hash"
    t.integer  "home_score"
    t.integer  "away_score"
    t.boolean  "played",         :default => false
    t.integer  "home_player_id"
    t.integer  "away_player_id"
    t.integer  "winner_id"
  end

  add_index "matches", ["away_player_id"], :name => "index_matches_on_away_player_id"
  add_index "matches", ["home_player_id"], :name => "index_matches_on_home_player_id"
  add_index "matches", ["match_hash"], :name => "index_matches_on_match_hash"

  create_table "rounds", :force => true do |t|
    t.integer  "tournament_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "tournaments", :force => true do |t|
    t.string   "description",                  :null => false
    t.string   "tournament_hash"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "game_type",       :limit => 1
    t.integer  "company_id"
  end

end
