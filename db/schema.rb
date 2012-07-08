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

ActiveRecord::Schema.define(:version => 20120708120842) do

  create_table "orders", :force => true do |t|
    t.integer  "shopify_id"
    t.string   "shipping_country_code"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "shop_id"
  end

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
