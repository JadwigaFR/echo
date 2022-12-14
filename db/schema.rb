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

ActiveRecord::Schema[7.0].define(version: 20_220_904_070_913) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "endpoints", force: :cascade do |t|
    t.string "verb", null: false
    t.string "path", null: false
    t.integer "response_code", null: false
    t.json "response_headers", default: {}
    t.text "response_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path", "verb"], name: "index_endpoints_on_path_and_verb", unique: true
  end
end
