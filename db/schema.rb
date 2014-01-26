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

ActiveRecord::Schema.define(version: 20140126012217) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "field_values", force: true do |t|
    t.integer  "project_id"
    t.integer  "field_id"
    t.integer  "user_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "field_values", ["field_id"], name: "index_field_values_on_field_id", using: :btree
  add_index "field_values", ["project_id"], name: "index_field_values_on_project_id", using: :btree
  add_index "field_values", ["user_id"], name: "index_field_values_on_user_id", using: :btree

  create_table "fields", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "placeholder"
    t.string   "input_type"
    t.boolean  "required"
    t.integer  "row_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "retrospective", default: false
  end

  create_table "memberships", force: true do |t|
    t.integer  "project_id",                 null: false
    t.integer  "user_id"
    t.integer  "role_id",                    null: false
    t.boolean  "accepted",   default: false, null: false
    t.boolean  "approved",   default: false, null: false
    t.boolean  "active",     default: true,  null: false
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                      null: false
  end

  add_index "memberships", ["project_id"], name: "index_memberships_on_project_id", using: :btree
  add_index "memberships", ["role_id"], name: "index_memberships_on_role_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "milestones", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "name"
    t.date     "date"
    t.boolean  "success"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "milestones", ["project_id"], name: "index_milestones_on_project_id", using: :btree
  add_index "milestones", ["user_id"], name: "index_milestones_on_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "aasm_state"
  end

  add_index "projects", ["status_id"], name: "index_projects_on_status_id", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",     default: 0
    t.integer  "filled_count", default: 0, null: false
    t.text     "description"
  end

  add_index "roles", ["project_id"], name: "index_roles_on_project_id", using: :btree

  create_table "series", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "series", ["user_id"], name: "index_series_on_user_id", using: :btree

  create_table "series_projects", force: true do |t|
    t.integer  "series_id"
    t.integer  "project_id"
    t.integer  "row_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "series_projects", ["project_id"], name: "index_series_projects_on_project_id", using: :btree
  add_index "series_projects", ["series_id"], name: "index_series_projects_on_series_id", using: :btree

  create_table "statuses", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "next_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "name"
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
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
