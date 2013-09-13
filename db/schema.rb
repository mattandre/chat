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

ActiveRecord::Schema.define(version: 20130726163416) do

  create_table "chats", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
  end

  add_index "chats", ["client_id"], name: "index_chats_on_client_id"

  create_table "clients", force: true do |t|
    t.string   "api_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.boolean  "active",     default: true
  end

  add_index "clients", ["owner_id"], name: "index_clients_on_owner_id"

  create_table "groups", force: true do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
  end

  add_index "groups", ["client_id"], name: "index_groups_on_client_id"

  create_table "groups_users", id: false, force: true do |t|
    t.integer "user_id",  null: false
    t.integer "group_id", null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id"
  add_index "groups_users", ["user_id", "group_id"], name: "index_groups_users_on_user_id_and_group_id"

  create_table "messages", force: true do |t|
    t.integer  "messagable_id"
    t.string   "messagable_type"
    t.integer  "chat_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["chat_id"], name: "index_messages_on_chat_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",              default: false
    t.integer  "client_id"
    t.string   "title"
    t.string   "set_password_token"
    t.boolean  "active",             default: false
    t.string   "ip"
    t.boolean  "accept_chats",       default: false
    t.integer  "chat_limit",         default: 5
  end

  add_index "users", ["client_id"], name: "index_users_on_client_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "visitors", force: true do |t|
    t.integer  "client_id"
    t.string   "remember_token"
    t.string   "ip"
    t.string   "browser_data"
    t.string   "current_url"
    t.datetime "last_visit"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
