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

ActiveRecord::Schema.define(version: 20180201160557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "alerts", force: :cascade do |t|
    t.string "type"
    t.bigint "widget_id"
    t.integer "occurring_rate"
    t.string "time_type"
    t.datetime "last_sent"
    t.string "phone_number"
    t.string "email_address"
    t.boolean "verified", default: false
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_sent_at"], name: "index_alerts_on_confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_alerts_on_confirmation_token"
    t.index ["email_address"], name: "index_alerts_on_email_address"
    t.index ["last_sent"], name: "index_alerts_on_last_sent"
    t.index ["occurring_rate"], name: "index_alerts_on_occurring_rate"
    t.index ["phone_number"], name: "index_alerts_on_phone_number"
    t.index ["time_type"], name: "index_alerts_on_time_type"
    t.index ["type"], name: "index_alerts_on_type"
    t.index ["verified"], name: "index_alerts_on_verified"
    t.index ["widget_id"], name: "index_alerts_on_widget_id"
  end

  create_table "bounds", force: :cascade do |t|
    t.float "upper_bound"
    t.float "lower_bound"
    t.bigint "widget_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lower_bound"], name: "index_bounds_on_lower_bound"
    t.index ["upper_bound"], name: "index_bounds_on_upper_bound"
    t.index ["widget_id"], name: "index_bounds_on_widget_id"
  end

  create_table "dashboards", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "layout"
    t.index ["layout"], name: "index_dashboards_on_layout"
    t.index ["name"], name: "index_dashboards_on_name"
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "data_values", id: :serial, force: :cascade do |t|
    t.integer "widget_id"
    t.float "value"
    t.datetime "recorded_at"
    t.boolean "in_bounds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "lower_bound"
    t.float "upper_bound"
    t.integer "lines_covered"
    t.integer "total_lines"
    t.integer "instance_count"
    t.float "total_used"
    t.index ["in_bounds"], name: "index_data_values_on_in_bounds"
    t.index ["recorded_at"], name: "index_data_values_on_recorded_at"
    t.index ["widget_id", "recorded_at"], name: "index_data_values_on_widget_id_and_recorded_at", unique: true
    t.index ["widget_id"], name: "index_data_values_on_widget_id"
  end

  create_table "golf_genius_employees", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "for_cc", default: false
    t.string "phone_number"
    t.index ["email"], name: "index_golf_genius_employees_on_email"
    t.index ["name"], name: "index_golf_genius_employees_on_name"
  end

  create_table "request_logs", force: :cascade do |t|
    t.integer "widget_id"
    t.string "description"
    t.text "parameters"
    t.float "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token"
    t.string "image"
    t.string "provider"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.string "uid"
    t.string "first_name"
    t.string "last_name"
    t.text "about_me"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "role", default: 0
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "widgets", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "dashboard_id"
    t.text "options"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_widgets_on_dashboard_id"
    t.index ["name"], name: "index_widgets_on_name"
    t.index ["options"], name: "index_widgets_on_options"
    t.index ["type"], name: "index_widgets_on_type"
  end

end
