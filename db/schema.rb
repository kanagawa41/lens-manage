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

ActiveRecord::Schema.define(version: 20170807151050) do

  create_table "collect_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "m_shop_info_id"
    t.integer "success_num"
    t.integer "fail_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_shop_info_id"], name: "index_collect_results_on_m_shop_info_id"
  end

  create_table "collect_targets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "m_shop_info_id"
    t.string "list_url"
    t.integer "start_page_num"
    t.integer "end_page_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_shop_info_id"], name: "index_collect_targets_on_m_shop_info_id"
  end

  create_table "collect_warehouses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "m_shop_info_id"
    t.string "row_collect_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_shop_info_id"], name: "index_collect_warehouses_on_m_shop_info_id"
  end

  create_table "image_download_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "m_shop_info_id"
    t.bigint "m_lens_info_id"
    t.string "lens_pic_url", null: false
    t.boolean "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_lens_info_id"], name: "index_image_download_histories_on_m_lens_info_id"
    t.index ["m_shop_info_id"], name: "index_image_download_histories_on_m_shop_info_id"
  end

  create_table "m_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "m_lens_info_id"
    t.string "path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_lens_info_id"], name: "index_m_images_on_m_lens_info_id"
    t.index ["path"], name: "index_m_images_on_path", unique: true
  end

  create_table "m_lens_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "lens_name"
    t.string "lens_pic_url"
    t.string "lens_info_url"
    t.string "stock_state"
    t.integer "price"
    t.bigint "m_shop_info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_shop_info_id"], name: "index_m_lens_infos_on_m_shop_info_id"
  end

  create_table "m_shop_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "shop_name"
    t.string "shop_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "collect_results", "m_shop_infos"
  add_foreign_key "collect_targets", "m_shop_infos"
  add_foreign_key "collect_warehouses", "m_shop_infos"
  add_foreign_key "image_download_histories", "m_lens_infos"
  add_foreign_key "image_download_histories", "m_shop_infos"
  add_foreign_key "m_images", "m_lens_infos"
  add_foreign_key "m_lens_infos", "m_shop_infos"
end
