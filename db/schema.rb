# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_22_184017) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "geolocations", force: :cascade do |t|
    t.string "ip"
    t.string "input"
    t.string "city"
    t.string "country"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "provider"
    t.string "type_of_ip"
    t.string "ip_version"
    t.string "continent_code"
    t.string "continent_name"
    t.string "country_code"
    t.string "country_name"
    t.string "region_code"
    t.string "region_name"
    t.string "zip"
    t.string "msa"
    t.string "dma"
    t.string "ip_routing_type"
    t.string "connection_type"
    t.integer "geoname_id"
    t.string "capital"
    t.string "country_flag"
    t.string "country_flag_emoji"
    t.string "calling_code"
    t.boolean "is_eu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
