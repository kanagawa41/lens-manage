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

ActiveRecord::Schema.define(version: 20170924095830) do

  create_table "active_admin_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

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
    t.boolean "disabled", default: false, null: false
    t.text "metadata", limit: 4294967295
    t.datetime "created_at", null: false
    t.string "memo"
    t.datetime "updated_at", null: false
    t.index ["m_shop_info_id"], name: "index_m_lens_infos_on_m_shop_info_id"
  end

  create_table "m_shop_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "shop_name"
    t.string "letter_code", null: false
    t.string "shop_url"
    t.boolean "disabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "search_char"
    t.string "search_condition_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transition_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "m_lens_info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_lens_info_id"], name: "index_transition_histories_on_m_lens_info_id"
  end

  add_foreign_key "collect_results", "m_shop_infos"
  add_foreign_key "collect_targets", "m_shop_infos"
  add_foreign_key "collect_warehouses", "m_shop_infos"
  add_foreign_key "image_download_histories", "m_lens_infos"
  add_foreign_key "image_download_histories", "m_shop_infos"
  add_foreign_key "m_images", "m_lens_infos"
  add_foreign_key "m_lens_infos", "m_shop_infos"
  add_foreign_key "transition_histories", "m_lens_infos"
end
