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

ActiveRecord::Schema.define(version: 20170713133126) do

  create_table "category_pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "range"
    t.boolean "complete_flag", default: false, null: false
    t.integer "m_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "html_warehouses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "item_id", null: false
    t.text "html"
    t.integer "http_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_brand_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "brand_group_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_brands", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "brand_name"
    t.integer "brand_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "category_name", null: false
    t.boolean "is_big_category", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_delivery_burdens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "burdender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_goods_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "status_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image_url1"
    t.string "image_url2"
    t.string "image_url3"
    t.string "image_url4"
    t.string "goods_name"
    t.text "goods_description"
    t.integer "price"
    t.integer "m_category_id1"
    t.integer "m_category_id2"
    t.integer "m_category_id3"
    t.integer "user_id"
    t.integer "m_goods_statuse_id"
    t.integer "m_brand_id"
    t.integer "m_delivery_burden_id"
    t.integer "m_prefecture"
    t.integer "like_num"
    t.text "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_prefectures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "prefecture_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "user_name"
    t.integer "good_rating"
    t.integer "normal_rating"
    t.integer "bad_rating"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
