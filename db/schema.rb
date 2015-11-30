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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151115033704) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "election_records", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "category",        null: false
    t.string   "onwork_title"
    t.string   "electorate"
    t.string   "party"
    t.date     "period_start"
    t.date     "period_end"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "election_result"
    t.integer  "election_id"
    t.string   "note"
  end

  add_index "election_records", ["election_id"], name: "index_election_records_on_election_id", using: :btree

  create_table "elections", force: :cascade do |t|
    t.string "name"
    t.date   "vote_date"
    t.string "description"
  end

  create_table "historical_agent_votes", force: :cascade do |t|
    t.integer  "agent_id"
    t.integer  "likes_count"
    t.integer  "dislikes_count"
    t.text     "liked_users"
    t.text     "disliked_users"
    t.date     "vote_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "historical_agent_votes", ["agent_id"], name: "index_historical_agent_votes_on_agent_id", using: :btree

  create_table "historical_issue_votes", force: :cascade do |t|
    t.integer  "issue_id"
    t.integer  "likes_count"
    t.text     "liked_users"
    t.date     "vote_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "historical_issue_votes", ["issue_id"], name: "index_historical_issue_votes_on_issue_id", using: :btree

  create_table "information", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "party"
    t.string   "job"
    t.string   "party_job"
    t.text     "experience"
    t.string   "election_position"
    t.string   "election_area"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "information", ["user_id"], name: "index_information_on_user_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "creator"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "votes_count"
  end

  create_table "latest_agent_votes", force: :cascade do |t|
    t.integer  "value"
    t.integer  "user_id"
    t.integer  "agent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "latest_agent_votes", ["user_id", "agent_id"], name: "index_latest_agent_votes_on_user_id_and_agent_id", using: :btree

  create_table "latest_issue_votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "latest_issue_votes", ["user_id", "issue_id"], name: "index_latest_issue_votes_on_user_id_and_issue_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",     null: false
    t.integer  "issue_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "taggings", ["issue_id"], name: "index_taggings_on_issue_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",                    null: false
    t.integer  "issue_count", default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "tags", ["issue_count"], name: "index_tags_on_issue_count", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "fb_image"
    t.string   "fb_uid"
    t.string   "fb_access_token"
    t.datetime "fb_expires_at"
    t.string   "authentication_token"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "country"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "name"
    t.string   "register_homecity"
    t.date     "birthday"
    t.string   "gender"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["fb_uid"], name: "index_users_on_fb_uid", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
