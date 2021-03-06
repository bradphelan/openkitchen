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

ActiveRecord::Schema.define(:version => 20120404090046) do

  create_table "assetable_assets", :force => true do |t|
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.integer  "asset_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "assetable_assets", ["assetable_id", "assetable_type", "asset_id"], :name => "assetable_assets_link", :unique => true

  create_table "assets", :force => true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "type"
    t.boolean  "attachment_processing"
    t.boolean  "terminated",              :default => false
  end

  add_index "assets", ["terminated"], :name => "index_assets_on_terminated"
  add_index "assets", ["type", "id"], :name => "by_type_and_id"

  create_table "commentable_subscriptions", :force => true do |t|
    t.integer "commentable_id"
    t.string  "commentable_type"
    t.integer "user_id"
    t.boolean "subscribed"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "events", :force => true do |t|
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.datetime "datetime"
    t.string   "timezone"
    t.text     "description"
    t.integer  "venue_id"
    t.boolean  "public",                               :default => false, :null => false
    t.integer  "public_seats",                         :default => 0
    t.boolean  "automatic_public_invitation_approval", :default => false
  end

  add_index "events", ["owner_id"], :name => "by_owner"
  add_index "events", ["venue_id"], :name => "index_events_on_venue_id"

  create_table "invitations", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "status",          :default => "pending"
    t.boolean  "public",          :default => false
    t.boolean  "public_approved", :default => false
  end

  add_index "invitations", ["event_id"], :name => "by_event"
  add_index "invitations", ["user_id", "event_id"], :name => "by_user_and_event", :unique => true

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "cookstars",           :default => 1
    t.string   "timezone"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "resource_producers", :force => true do |t|
    t.integer   "invitation_id"
    t.integer   "resource_id"
    t.integer   "quantity"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string    "name"
    t.integer   "quantity"
    t.string    "units"
    t.integer   "event_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "user_venue_managements", :force => true do |t|
    t.integer "user_id"
    t.integer "venue_id"
    t.string  "role"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "name"
    t.integer  "cookstars",                             :default => 1
    t.string   "timezone",                              :default => "UTC"
    t.text     "about",                                 :default => ""
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venues", :force => true do |t|
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "name"
    t.string   "timezone"
    t.string   "street"
    t.string   "city"
    t.string   "country"
    t.string   "postcode"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.text     "description", :default => ""
  end

end
