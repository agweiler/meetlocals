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

ActiveRecord::Schema.define(version: 20160112011007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "username"
    t.integer  "commision_percentage",   default: 10
  end

  add_index "admins", ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true, using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "authentications", force: :cascade do |t|
    t.integer  "guest_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.text     "add_info"
    t.boolean  "host_paid",           default: false
    t.integer  "no_of_adults",        default: 0
    t.integer  "no_of_children",      default: 0
  end

  add_index "bookings", ["experience_id"], name: "index_bookings_on_experience_id", using: :btree
  add_index "bookings", ["guest_id"], name: "index_bookings_on_guest_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "iso_two_letter_code"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "exp_images", force: :cascade do |t|
    t.integer  "experience_id"
    t.integer  "image_number"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "finished"
    t.string   "local_image_file_name"
    t.string   "local_image_content_type"
    t.integer  "local_image_file_size"
    t.datetime "local_image_updated_at"
    t.string   "image_file_file_name"
    t.string   "image_file_content_type"
    t.integer  "image_file_file_size"
    t.datetime "image_file_updated_at"
    t.string   "temp_file_key"
  end

  create_table "experiences", force: :cascade do |t|
    t.string   "title"
    t.float    "duration"
    t.string   "cuisine"
    t.integer  "max_group_size"
    t.text     "host_style"
    t.string   "available_days", default: "-------"
    t.float    "price",          default: 0.0
    t.integer  "host_id",                            null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "location"
    t.time     "time"
    t.string   "beverages"
    t.string   "meal"
    t.string   "mealset"
    t.date     "date"
  end

  add_index "experiences", ["host_id"], name: "index_experiences_on_host_id", using: :btree

  create_table "guests", force: :cascade do |t|
    t.string   "username",               default: "",    null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
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
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "languages"
    t.string   "nationality"
    t.string   "country"
    t.text     "interests"
    t.string   "allergies"
    t.boolean  "filled",                 default: false, null: false
    t.string   "profession"
  end

  add_index "guests", ["confirmation_token"], name: "index_guests_on_confirmation_token", unique: true, using: :btree
  add_index "guests", ["email"], name: "index_guests_on_email", unique: true, using: :btree
  add_index "guests", ["reset_password_token"], name: "index_guests_on_reset_password_token", unique: true, using: :btree

  create_table "holidays", force: :cascade do |t|
    t.date     "date"
    t.string   "note"
    t.integer  "host_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "holidays", ["host_id"], name: "index_holidays_on_host_id", using: :btree

  create_table "hosts", force: :cascade do |t|
    t.string   "username",                                       default: "",    null: false
    t.string   "email",                                          default: "",    null: false
    t.string   "encrypted_password",                             default: "",    null: false
    t.string   "country",                                        default: "",    null: false
    t.string   "state",                                          default: "",    null: false
    t.string   "suburb",                                         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                  default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "languages"
    t.string   "street_address"
    t.text     "neighbourhood"
    t.date     "dob"
    t.string   "video_url"
    t.string   "occupation"
    t.text     "interests"
    t.boolean  "smoker"
    t.string   "pets"
    t.boolean  "approved",                                       default: false, null: false
    t.integer  "max_group_size"
    t.string   "phone"
    t.decimal  "revenue",                precision: 8, scale: 2, default: 0.0
    t.string   "bank_name"
    t.string   "bank_number"
    t.string   "registration_number"
    t.string   "host_presentation"
    t.integer  "experiences_count"
    t.string   "zip"
  end

  add_index "hosts", ["confirmation_token"], name: "index_hosts_on_confirmation_token", unique: true, using: :btree
  add_index "hosts", ["email"], name: "index_hosts_on_email", unique: true, using: :btree
  add_index "hosts", ["reset_password_token"], name: "index_hosts_on_reset_password_token", unique: true, using: :btree

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
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "image_file_file_name"
    t.string   "image_file_content_type"
    t.integer  "image_file_file_size"
    t.datetime "image_file_updated_at"
    t.string   "local_image_file_name"
    t.string   "local_image_content_type"
    t.integer  "local_image_file_size"
    t.datetime "local_image_updated_at"
    t.string   "direct_upload_url"
    t.string   "image_file_file_path"
    t.string   "temp_file_key"
    t.boolean  "finished"
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

  create_table "multidinners", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "group_sizes",  default: [],              array: true
    t.string   "hosts_chosen", default: [],              array: true
    t.integer  "partner_id"
  end

  create_table "nationalities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "host_id"
    t.integer  "type_id"
    t.string   "type_of"
    t.boolean  "seen",       default: false
    t.integer  "guest_id"
  end

  add_index "notifications", ["guest_id", "type_of"], name: "index_notifications_on_guest_id_and_type_of", using: :btree
  add_index "notifications", ["host_id", "type_of"], name: "index_notifications_on_host_id_and_type_of", using: :btree

  create_table "partners", force: :cascade do |t|
    t.string   "username"
    t.string   "address"
    t.string   "contact_info"
    t.string   "string"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "partners", ["email"], name: "index_partners_on_email", unique: true, using: :btree
  add_index "partners", ["reset_password_token"], name: "index_partners_on_reset_password_token", unique: true, using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "video_url"
    t.string   "post_type"
  end

  add_index "posts", ["post_type"], name: "index_posts_on_post_type", using: :btree

  create_table "prices", force: :cascade do |t|
    t.string "meal"
    t.float  "price"
  end

  create_table "site_images", force: :cascade do |t|
    t.string   "name"
    t.string   "local_image_file_name"
    t.string   "local_image_content_type"
    t.integer  "local_image_file_size"
    t.datetime "local_image_updated_at"
    t.string   "image_file_file_name"
    t.string   "image_file_content_type"
    t.integer  "image_file_file_size"
    t.datetime "image_file_updated_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "temp_file_key"
    t.integer  "image_number"
  end

  create_table "static_texts", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "video_url"
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
