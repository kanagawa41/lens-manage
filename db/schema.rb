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

ActiveRecord::Schema.define(version: 20170723014706) do

  create_table "collect_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "m_shop_info_id"
    t.boolean "is_done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_shop_info_id"], name: "index_collect_results_on_m_shop_info_id"
  end

  create_table "collect_targets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "m_shop_info_id"
    t.string "list_url"
    t.integer "page_num"
    t.boolean "is_done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_shop_info_id"], name: "index_collect_targets_on_m_shop_info_id"
  end

  create_table "m_lends_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "lends_name"
    t.string "lends_pic_url"
    t.string "stock_state"
    t.integer "price"
    t.bigint "m_shop_info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_shop_info_id"], name: "index_m_lends_infos_on_m_shop_info_id"
  end

  create_table "m_shop_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "shop_name"
    t.string "shop_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "collect_results", "m_shop_infos"
  add_foreign_key "collect_targets", "m_shop_infos"
  add_foreign_key "m_lends_infos", "m_shop_infos"
end
