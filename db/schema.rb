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

ActiveRecord::Schema.define(version: 20161220175235) do

  create_table "charges", force: :cascade do |t|
    t.boolean  "completed"
    t.float    "amount"
    t.integer  "expense_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "charges", ["expense_id"], name: "index_charges_on_expense_id"
  add_index "charges", ["user_id"], name: "index_charges_on_user_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
  end

  add_index "delayed_jobs", ["owner_type", "owner_id"], name: "index_delayed_jobs_on_owner_type_and_owner_id"
  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "expenses", force: :cascade do |t|
    t.string   "name"
    t.float    "amount"
    t.datetime "date"
    t.string   "category"
    t.string   "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.datetime "deadline"
  end

  add_index "expenses", ["user_id"], name: "index_expenses_on_user_id"

  create_table "fine_rules", force: :cascade do |t|
    t.integer "amount"
    t.boolean "reminder"
    t.integer "days_before_deadline"
    t.integer "house_id"
  end

  add_index "fine_rules", ["house_id"], name: "index_fine_rules_on_house_id"

  create_table "houses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "landlords", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "address"
    t.string   "best_contact_method"
    t.string   "notes"
    t.integer  "house_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "landlords", ["house_id"], name: "index_landlords_on_house_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "password_digest"
    t.integer  "house_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "phone_number"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

  add_index "users", ["house_id"], name: "index_users_on_house_id"

end
