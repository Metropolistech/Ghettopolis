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

ActiveRecord::Schema.define(version: 20160205104801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "backstage_post_accesses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "backstage_post_accesses", ["project_id"], name: "index_backstage_post_accesses_on_project_id", using: :btree
  add_index "backstage_post_accesses", ["user_id"], name: "index_backstage_post_accesses_on_user_id", using: :btree

  create_table "backstage_posts", force: :cascade do |t|
    t.integer  "project_id"
    t.text     "content"
    t.integer  "image_id"
    t.string   "youtube_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "backstage_posts", ["image_id"], name: "index_backstage_posts_on_image_id", using: :btree
  add_index "backstage_posts", ["project_id"], name: "index_backstage_posts_on_project_id", using: :btree

  create_table "follow_projects", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "follow_projects", ["project_id"], name: "index_follow_projects_on_project_id", using: :btree
  add_index "follow_projects", ["user_id"], name: "index_follow_projects_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "url"
    t.integer  "height"
    t.integer  "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notification_types", force: :cascade do |t|
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "notification_type_id"
    t.datetime "seen_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "notif_duty_type"
    t.integer  "notif_duty_id"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.string   "youtube_id"
    t.integer  "room_max"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "author_id"
    t.integer  "cover_id"
    t.string   "status",      default: "draft"
    t.text     "description"
    t.jsonb    "comments",    default: {},      null: false
  end

  add_index "projects", ["author_id"], name: "index_projects_on_author_id", using: :btree
  add_index "projects", ["comments"], name: "index_projects_on_comments", using: :gin

  create_table "team_role_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "team_roles_id"
  end

  add_index "team_role_types", ["team_roles_id"], name: "index_team_role_types_on_team_roles_id", using: :btree

  create_table "team_roles", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "team_roles", ["project_id"], name: "index_team_roles_on_project_id", using: :btree
  add_index "team_roles", ["user_id"], name: "index_team_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "is_admin",               default: false
    t.boolean  "is_creator",             default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "backstage_post_accesses", "projects"
  add_foreign_key "backstage_post_accesses", "users"
  add_foreign_key "backstage_posts", "images"
  add_foreign_key "backstage_posts", "projects"
  add_foreign_key "follow_projects", "projects"
  add_foreign_key "follow_projects", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "team_roles", "projects"
  add_foreign_key "team_roles", "users"
end
