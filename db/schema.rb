# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_21_021853) do

  create_table "monsters", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "todos", force: :cascade do |t|
    t.integer "user_id"
    t.string "tag"
    t.integer "level"
    t.boolean "status", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.text "explanation"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "monstar_id", default: 1
    t.integer "level", default: 1
    t.integer "hp", default: 10
    t.integer "ep", default: 0
    t.integer "physical", default: 0
    t.integer "intelligence", default: 0
    t.integer "lifestyle", default: 0
    t.integer "others", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password"
    t.string "token"
    t.index ["token"], name: "index_users_on_token", unique: true
  end

end
