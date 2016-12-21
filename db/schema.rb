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

ActiveRecord::Schema.define(version: 20161221091312) do

  create_table "clouds", force: :cascade do |t|
    t.string   "key",       limit: 255
    t.string   "size",      limit: 255
    t.string   "mine_type", limit: 255
    t.string   "md5_value", limit: 255
    t.datetime "upload_at"
  end

  create_table "columns", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "english",    limit: 255
    t.string   "icon",       limit: 255
    t.string   "cover",      limit: 255
    t.text     "summary",    limit: 65535
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "avatar",     limit: 255,   default: ""
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "video_id",   limit: 4
    t.integer  "reply_id",   limit: 4
    t.integer  "vote",       limit: 4
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "user_action_logs", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "action",     limit: 255
    t.string   "result",     limit: 255
    t.string   "local_ip",   limit: 255
    t.string   "location",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.integer  "role",                   limit: 4,   default: 1
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "nick_name",              limit: 255
    t.string   "avatar",                 limit: 255
    t.string   "phone",                  limit: 255
    t.string   "location",               limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.integer  "column_id",  limit: 4
    t.string   "url_code",   limit: 255
    t.integer  "recommend",  limit: 4,     default: 0
    t.integer  "video_type", limit: 4
    t.string   "video_url",  limit: 255,               null: false
    t.string   "title",      limit: 255
    t.string   "cover",      limit: 255
    t.string   "duration",   limit: 255
    t.text     "summary",    limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "view_count", limit: 8,     default: 0
  end

  add_index "videos", ["url_code"], name: "index_videos_on_url_code", unique: true, using: :btree

end
