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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120715123252) do

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "countries", ["code"], :name => "index_countries_on_code"

  create_table "crowns", :force => true do |t|
    t.string   "country_name"
    t.integer  "shop_id"
    t.datetime "lost_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "country_id"
  end

  add_index "crowns", ["country_id"], :name => "index_crowns_on_country_id"
  add_index "crowns", ["shop_id"], :name => "index_crowns_on_shop_id"

  create_table "orders", :force => true do |t|
    t.integer  "shopify_id"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "shop_id"
    t.integer  "country_id"
    t.decimal  "total_price_usd",    :precision => 12, :scale => 2
    t.decimal  "total_price",        :precision => 12, :scale => 2
    t.string   "currency"
    t.string   "financial_status"
    t.string   "fulfillment_status"
  end

  add_index "orders", ["country_id"], :name => "index_orders_on_country_id"
  add_index "orders", ["shop_id"], :name => "index_orders_on_shop_id"

  create_table "shops", :force => true do |t|
    t.integer  "shopify_id"
    t.string   "country"
    t.datetime "shopify_created_at"
    t.string   "domain"
    t.string   "email"
    t.string   "name"
    t.string   "currency"
    t.string   "timezone"
    t.string   "shop_owner"
    t.string   "plan_name"
    t.string   "myshopify_domain",   :null => false
    t.string   "access_token"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
