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

ActiveRecord::Schema.define(version: 20160814013956) do

  create_table "charges", force: :cascade do |t|
    t.boolean  "completed"
    t.float    "amount"
    t.integer  "expense_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "charged_to_id"
  end

  add_index "charges", ["charged_to_id"], name: "index_charges_on_charged_to_id"
  add_index "charges", ["expense_id"], name: "index_charges_on_expense_id"

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
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "expenses", force: :cascade do |t|
    t.string   "name"
    t.float    "amount"
    t.datetime "date"
    t.string   "category"
    t.string   "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "paid_by_id"
    t.datetime "deadline"
  end

  add_index "expenses", ["paid_by_id"], name: "index_expenses_on_paid_by_id"

  create_table "houses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
  end

  add_index "users", ["house_id"], name: "index_users_on_house_id"

end
