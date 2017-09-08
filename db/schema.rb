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

ActiveRecord::Schema.define(version: 20170804094434) do

  create_table "books", force: :cascade do |t|
    t.integer  "vecchioid"
    t.string   "titolo"
    t.decimal  "prezzoeurodec"
    t.string   "edizione"
    t.string   "isbn"
    t.integer  "copie"
    t.boolean  "deposito"
    t.integer  "publisher_id"
    t.integer  "idtipoopera"
    t.integer  "annoedizione"
    t.string   "note"
    t.integer  "idaliquotaiva"
    t.string   "url2"
    t.integer  "annomodifica"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lbooks", force: :cascade do |t|
    t.integer  "c01_vecchioid"
    t.string   "c02_titolo"
    t.string   "c03_prezzoeurodec"
    t.string   "c04_EDIZIONE"
    t.integer  "c05_IDDISTRIBUTORE"
    t.integer  "c06_IDSERIE"
    t.string   "c07_ISBN"
    t.integer  "c08_copie"
    t.boolean  "c09_deposito"
    t.integer  "c10_publisher_id"
    t.integer  "c11_IDTIPOOPERA"
    t.integer  "c12_ANNOEDIZIONE"
    t.string   "c13_note"
    t.integer  "c14_idaliquotaiva"
    t.string   "c15_url2"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "quantity",   default: 1
    t.integer  "order_id"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
  end

  create_table "lpublishers", force: :cascade do |t|
    t.integer  "ID_EDITORE"
    t.string   "Nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.integer  "pay_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.decimal  "price",       precision: 8, scale: 2
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "publishers", force: :cascade do |t|
    t.string   "nome"
    t.integer  "vecchioid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.string   "termine"
    t.string   "tabella"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
