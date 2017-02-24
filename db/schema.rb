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

ActiveRecord::Schema.define(version: 20170222140648) do

  create_table "branches", force: :cascade do |t|
    t.string   "code",       limit: 4
    t.string   "name",       limit: 50
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["code"], name: "index_branches_on_code"
  end

  create_table "children", force: :cascade do |t|
    t.string   "code",       limit: 9
    t.string   "name",       limit: 250
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["code"], name: "index_children_on_code"
  end

  create_table "children_categories", force: :cascade do |t|
    t.integer  "children_categories_type_id"
    t.string   "code",                        limit: 9
    t.string   "name",                        limit: 50
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["children_categories_type_id"], name: "index_children_categories_on_children_categories_type_id"
    t.index ["code"], name: "index_children_categories_on_code"
  end

  create_table "children_categories_types", force: :cascade do |t|
    t.string   "code",       limit: 9
    t.string   "name",       limit: 50
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["code"], name: "index_children_categories_types_on_code"
  end

  create_table "children_day_costs", force: :cascade do |t|
    t.integer  "children_category_id"
    t.date     "cost_date"
    t.decimal  "cost",                 precision: 8, scale: 2
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["children_category_id"], name: "index_children_day_costs_on_children_category_id"
    t.index ["cost_date"], name: "index_children_day_costs_on_cost_date"
  end

  create_table "children_groups", force: :cascade do |t|
    t.integer  "children_category_id"
    t.string   "code",                 limit: 9
    t.string   "name",                 limit: 30
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["children_category_id"], name: "index_children_groups_on_children_category_id"
    t.index ["code"], name: "index_children_groups_on_code"
  end

  create_table "institution_order_products", force: :cascade do |t|
    t.integer  "institution_order_id"
    t.integer  "product_id"
    t.date     "date"
    t.decimal  "count",                            precision: 8, scale: 3
    t.string   "description",          limit: 100
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.index ["date"], name: "index_institution_order_products_on_date"
    t.index ["institution_order_id"], name: "index_institution_order_products_on_institution_order_id"
    t.index ["product_id"], name: "index_institution_order_products_on_product_id"
  end

  create_table "institution_orders", force: :cascade do |t|
    t.integer  "institution_id"
    t.date     "date_start"
    t.date     "date_end"
    t.date     "date_sa"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "number",         limit: 12
    t.date     "date"
    t.string   "number_sa",      limit: 12
    t.index ["date"], name: "index_institution_orders_on_date"
    t.index ["date_end"], name: "index_institution_orders_on_date_end"
    t.index ["date_start"], name: "index_institution_orders_on_date_start"
    t.index ["institution_id"], name: "index_institution_orders_on_institution_id"
    t.index ["number"], name: "index_institution_orders_on_number"
  end

  create_table "institutions", force: :cascade do |t|
    t.integer  "branch_id"
    t.string   "code",       limit: 9
    t.string   "name",       limit: 50
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["branch_id"], name: "index_institutions_on_branch_id"
    t.index ["code"], name: "index_institutions_on_code"
  end

  create_table "io_correction_products", force: :cascade do |t|
    t.integer  "io_correction_id"
    t.integer  "product_id"
    t.date     "date"
    t.decimal  "diff",                         precision: 8, scale: 3
    t.string   "description",      limit: 100
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.index ["date"], name: "index_io_correction_products_on_date"
    t.index ["io_correction_id"], name: "index_io_correction_products_on_io_correction_id"
    t.index ["product_id"], name: "index_io_correction_products_on_product_id"
  end

  create_table "io_corrections", force: :cascade do |t|
    t.integer  "institution_order_id"
    t.string   "number",               limit: 12
    t.date     "date"
    t.date     "date_sa"
    t.string   "number_sa",            limit: 12
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["date"], name: "index_io_corrections_on_date"
    t.index ["institution_order_id"], name: "index_io_corrections_on_institution_order_id"
    t.index ["number"], name: "index_io_corrections_on_number"
  end

  create_table "menu_children_categories", force: :cascade do |t|
    t.integer  "menu_requirement_id"
    t.integer  "children_category_id"
    t.integer  "count_all_plan",       limit: 4, default: 0, null: false
    t.integer  "count_exemption_plan", limit: 4, default: 0, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "count_all_fact",       limit: 4, default: 0, null: false
    t.integer  "count_exemption_fact", limit: 4, default: 0, null: false
    t.index ["children_category_id"], name: "index_menu_children_categories_on_children_category_id"
    t.index ["menu_requirement_id"], name: "index_menu_children_categories_on_menu_requirement_id"
  end

  create_table "menu_products", force: :cascade do |t|
    t.integer  "menu_requirement_id"
    t.integer  "children_category_id"
    t.integer  "product_id"
    t.decimal  "count_plan",           precision: 8, scale: 3, default: "0.0"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.decimal  "count_fact",           precision: 8, scale: 3, default: "0.0"
    t.index ["children_category_id"], name: "index_menu_products_on_children_category_id"
    t.index ["menu_requirement_id"], name: "index_menu_products_on_menu_requirement_id"
    t.index ["product_id"], name: "index_menu_products_on_product_id"
  end

  create_table "menu_requirements", force: :cascade do |t|
    t.integer  "branch_id"
    t.integer  "institution_id"
    t.string   "number",         limit: 12
    t.date     "date"
    t.date     "splendingdate"
    t.date     "date_sap"
    t.date     "date_saf"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "number_sap",     limit: 12
    t.string   "number_saf",     limit: 12
    t.index ["branch_id"], name: "index_menu_requirements_on_branch_id"
    t.index ["date"], name: "index_menu_requirements_on_date"
    t.index ["institution_id"], name: "index_menu_requirements_on_institution_id"
    t.index ["number"], name: "index_menu_requirements_on_number"
  end

  create_table "price_products", force: :cascade do |t|
    t.integer  "product_id"
    t.date     "price_date"
    t.decimal  "price",          precision: 8, scale: 2
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "branch_id"
    t.integer  "institution_id"
    t.index ["branch_id"], name: "index_price_products_on_branch_id"
    t.index ["institution_id"], name: "index_price_products_on_institution_id"
    t.index ["price_date"], name: "index_price_products_on_price_date"
    t.index ["product_id"], name: "index_price_products_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "code",       limit: 9
    t.string   "name",       limit: 50
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["code"], name: "index_products_on_code"
  end

  create_table "reasons_absences", force: :cascade do |t|
    t.string   "code",       limit: 9
    t.string   "mark",       limit: 3
    t.string   "name",       limit: 30
    t.integer  "priority",   limit: 2
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["code"], name: "index_reasons_absences_on_code"
  end

  create_table "receipt_products", force: :cascade do |t|
    t.integer  "receipt_id"
    t.integer  "product_id"
    t.date     "date"
    t.decimal  "count",      precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["date"], name: "index_receipt_products_on_date"
    t.index ["product_id"], name: "index_receipt_products_on_product_id"
    t.index ["receipt_id"], name: "index_receipt_products_on_receipt_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.integer  "supplier_order_id"
    t.integer  "institution_id"
    t.string   "contract_number",   limit: 12
    t.string   "invoice_number",    limit: 12
    t.date     "date"
    t.date     "date_sa"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "number_sa",         limit: 12
    t.string   "number",            limit: 12
    t.index ["contract_number"], name: "index_receipts_on_contract_number"
    t.index ["date"], name: "index_receipts_on_date"
    t.index ["institution_id"], name: "index_receipts_on_institution_id"
    t.index ["number"], name: "index_receipts_on_number"
    t.index ["supplier_order_id"], name: "index_receipts_on_supplier_order_id"
  end

  create_table "supplier_order_products", force: :cascade do |t|
    t.integer  "supplier_order_id"
    t.integer  "institution_id"
    t.integer  "product_id"
    t.string   "contract_number",   limit: 12
    t.date     "date"
    t.decimal  "count",                        precision: 8, scale: 3
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.index ["contract_number"], name: "index_supplier_order_products_on_contract_number"
    t.index ["date"], name: "index_supplier_order_products_on_date"
    t.index ["institution_id"], name: "index_supplier_order_products_on_institution_id"
    t.index ["product_id"], name: "index_supplier_order_products_on_product_id"
    t.index ["supplier_order_id"], name: "index_supplier_order_products_on_supplier_order_id"
  end

  create_table "supplier_orders", force: :cascade do |t|
    t.integer  "branch_id"
    t.integer  "supplier_id"
    t.string   "number",      limit: 12
    t.date     "date"
    t.date     "date_start"
    t.date     "date_end"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["branch_id"], name: "index_supplier_orders_on_branch_id"
    t.index ["date"], name: "index_supplier_orders_on_date"
    t.index ["number"], name: "index_supplier_orders_on_number"
    t.index ["supplier_id"], name: "index_supplier_orders_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "code",       limit: 10
    t.string   "name",       limit: 50
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["code"], name: "index_suppliers_on_code"
  end

  create_table "timesheet_dates", force: :cascade do |t|
    t.integer  "timesheet_id"
    t.integer  "children_group_id"
    t.integer  "child_id"
    t.integer  "reasons_absence_id"
    t.date     "date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["child_id"], name: "index_timesheet_dates_on_child_id"
    t.index ["children_group_id"], name: "index_timesheet_dates_on_children_group_id"
    t.index ["date"], name: "index_timesheet_dates_on_date"
    t.index ["reasons_absence_id"], name: "index_timesheet_dates_on_reasons_absence_id"
    t.index ["timesheet_id"], name: "index_timesheet_dates_on_timesheet_id"
  end

  create_table "timesheets", force: :cascade do |t|
    t.integer  "branch_id"
    t.integer  "institution_id"
    t.string   "number",         limit: 12
    t.date     "date"
    t.date     "date_sa"
    t.string   "number_sa",      limit: 12
    t.date     "date_vb"
    t.date     "date_ve"
    t.date     "date_eb"
    t.date     "date_ee"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["branch_id"], name: "index_timesheets_on_branch_id"
    t.index ["date"], name: "index_timesheets_on_date"
    t.index ["institution_id"], name: "index_timesheets_on_institution_id"
    t.index ["number"], name: "index_timesheets_on_number"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "institution_id"
    t.integer  "supplier_id"
    t.string   "username"
    t.string   "password_digest"
    t.boolean  "is_admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["institution_id"], name: "index_users_on_institution_id"
    t.index ["supplier_id"], name: "index_users_on_supplier_id"
    t.index ["username"], name: "index_users_on_username"
  end

end
