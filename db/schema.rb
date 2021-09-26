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

ActiveRecord::Schema.define(version: 2021_09_26_030837) do

  create_table "favorites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_id"], name: "index_favorites_on_store_id"
    t.index ["user_id", "store_id"], name: "index_favorites_on_user_id_and_store_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.float "rating", default: 0.0, null: false
    t.text "comment", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_id", "user_id"], name: "index_reviews_on_store_id_and_user_id", unique: true
    t.index ["store_id"], name: "index_reviews_on_store_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "stores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "introduction", null: false
    t.integer "postcode", null: false
    t.string "prefecture_code", null: false
    t.string "city", null: false
    t.string "url"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "favorites_count", default: 0, null: false
    t.integer "reviews_count", default: 0, null: false
    t.float "latitude"
    t.float "longitude"
    t.boolean "nursing_room", default: false
    t.boolean "diaper_changing_area", default: false
    t.boolean "hot_water", default: false
    t.boolean "stroller_rental", default: false
    t.boolean "kids_space", default: false
    t.boolean "large_space", default: false
    t.boolean "height_and_weight_scales", default: false
    t.boolean "microwave_oven", default: false
    t.boolean "basin", default: false
    t.boolean "toilet_with_baby_chair", default: false
    t.boolean "tatami_room", default: false
    t.boolean "private_room", default: false
    t.boolean "baby_food", default: false
    t.boolean "stroller_access", default: false
    t.boolean "baby_chair", default: false
    t.index ["city"], name: "index_stores_on_city", unique: true
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.text "introduction"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "favorites", "stores"
  add_foreign_key "favorites", "users"
  add_foreign_key "reviews", "stores"
  add_foreign_key "reviews", "users"
  add_foreign_key "stores", "users"
end
