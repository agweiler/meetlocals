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

ActiveRecord::Schema.define(version: 20150305081251) do

  create_table "admins", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "bookings", force: :cascade do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.date     "date"
    t.integer  "guest_id"
    t.integer  "experience_id"
    t.string   "status",              default: "requested"
    t.integer  "group_size"
    t.boolean  "is_private"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.text     "notification_params"
    t.string   "transaction_id"
    t.datetime "purchased_at"
  end

  create_table "experiences", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.float    "duration"
    t.boolean  "is_halal"
    t.string   "cuisine"
    t.integer  "max_group_size"
    t.text     "host_style"
    t.string   "available_days", default: "-------"
    t.float    "price"
    t.integer  "host_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "location"
    t.time     "time"
  end

  create_table "guests", force: :cascade do |t|
    t.string   "username",               default: "", null: false
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "about",                  default: ""
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "guests", ["confirmation_token"], name: "index_guests_on_confirmation_token", unique: true
  add_index "guests", ["email"], name: "index_guests_on_email", unique: true
  add_index "guests", ["reset_password_token"], name: "index_guests_on_reset_password_token", unique: true

  create_table "hosts", force: :cascade do |t|
    t.string   "username",               default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.date     "DOB"
    t.string   "country",                default: "", null: false
    t.string   "state",                  default: "", null: false
    t.string   "suburb",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "hosts", ["confirmation_token"], name: "index_hosts_on_confirmation_token", unique: true
  add_index "hosts", ["email"], name: "index_hosts_on_email", unique: true
  add_index "hosts", ["reset_password_token"], name: "index_hosts_on_reset_password_token", unique: true

  create_table "hosts_languages", id: false, force: :cascade do |t|
    t.integer "host_id",     null: false
    t.integer "language_id", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "title"
    t.string   "link"
    t.string   "caption"
    t.string   "alt_text"
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "image_file_file_name"
    t.string   "image_file_content_type"
    t.integer  "image_file_file_size"
    t.datetime "image_file_updated_at"
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "text"
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "booking_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "testimonials", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.integer  "booking_id"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
