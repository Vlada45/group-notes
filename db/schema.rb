# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_09_195012) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "public.note_collaborators", force: :cascade do |t|
    t.boolean "can_edit"
    t.datetime "created_at", null: false
    t.bigint "note_id", null: false
    t.datetime "shared_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["note_id"], name: "index_note_collaborators_on_note_id"
    t.index ["user_id"], name: "index_note_collaborators_on_user_id"
  end

  create_table "public.notes", force: :cascade do |t|
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "heading", null: false
    t.boolean "starred", default: false, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "public.users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "uid"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "public.note_collaborators", "public.notes"
  add_foreign_key "public.note_collaborators", "public.users"
  add_foreign_key "public.notes", "public.users"

end
