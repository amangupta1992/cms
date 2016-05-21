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

ActiveRecord::Schema.define(version: 20160521163559) do

  create_table "applied_coupons", force: :cascade do |t|
    t.integer  "user_id",    limit: 11
    t.integer  "coupon_id",  limit: 11,                 null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "is_delete",             default: false, null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "coupon_code",                            null: false
    t.string   "coupon_type",                            null: false
    t.datetime "valid_upto"
    t.integer  "usage_count", limit: 11
    t.integer  "usage_limit", limit: 11
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_delete",              default: false, null: false
  end

end
