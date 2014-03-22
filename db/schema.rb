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

ActiveRecord::Schema.define(version: 20140322062431) do

  create_table "ask_a_question_requests", force: true do |t|
    t.integer  "product_id", null: false
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.text     "question",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "contact_requests", force: true do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.string   "phone"
    t.string   "subject"
    t.text     "message",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "images", force: true do |t|
    t.string   "alt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "navigation_items", force: true do |t|
    t.string   "menu_name",           default: "main"
    t.integer  "parent_id"
    t.integer  "order_within_parent", default: 1
    t.string   "href"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "navigation_items", ["deleted_at"], name: "index_navigation_items_on_deleted_at"

  create_table "product_badge_css_classes", force: true do |t|
    t.string "name", null: false
  end

  create_table "product_badges", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "product_badge_css_class_id"
  end

  add_index "product_badges", ["product_badge_css_class_id"], name: "index_product_badges_on_product_badge_css_class_id"

  create_table "product_ranges", force: true do |t|
    t.string "name", null: false
  end

  create_table "products", force: true do |t|
    t.string   "name",                                null: false
    t.text     "blurb_html"
    t.text     "details_html"
    t.text     "how_to_wear_it_html"
    t.decimal  "price_in_aud",                        null: false
    t.decimal  "price_in_usd",                        null: false
    t.boolean  "new_arrival",         default: false, null: false
    t.boolean  "most_popular",        default: false, null: false
    t.boolean  "gift_idea",           default: false, null: false
    t.integer  "priority",            default: 100,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "product_badge_id"
    t.integer  "stock_level",         default: 0,     null: false
    t.integer  "product_range_id"
  end

  add_index "products", ["product_badge_id"], name: "index_products_on_product_badge_id"
  add_index "products", ["product_range_id"], name: "index_products_on_product_range_id"

end
