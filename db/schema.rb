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

ActiveRecord::Schema.define(version: 20170626130854) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reserves", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "url"
    t.time "wait_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "url_group_id"
    t.index ["url_group_id"], name: "index_reserves_on_url_group_id"
  end

  create_table "task_queues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.time "regist_time"
    t.time "late_time"
    t.boolean "complete_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reserve_id"
    t.index ["reserve_id"], name: "index_task_queues_on_reserve_id"
  end

  create_table "url_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "warehouses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "html"
    t.integer "http_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reserve_id"
    t.index ["reserve_id"], name: "index_warehouses_on_reserve_id"
  end

  add_foreign_key "reserves", "url_groups"
  add_foreign_key "task_queues", "reserves", column: "reserve_id"
  add_foreign_key "warehouses", "reserves", column: "reserve_id"
end
