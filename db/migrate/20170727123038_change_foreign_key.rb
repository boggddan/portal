class ChangeForeignKey < ActiveRecord::Migration[5.1]
  def change
    tables = [
      [ :timesheets, :branches ],
      [ :menu_requirements, :branches ],
      [ :supplier_orders, :branches ],
      [ :price_products, :branches ],
      [ :institutions, :branches ],
      [ :timesheet_dates, :children ],
      [ :children_categories, :children_categories_types ],
      [ :menu_products, :children_categories ],
      [ :children_day_costs, :children_categories ],
      [ :children_groups, :children_categories ],
      [ :menu_children_categories, :children_categories ],
      [ :timesheet_dates, :children_groups ],
      [ :menu_meals_dishes, :dishes ],
      [ :dishes, :dishes_categories ],
      [ :price_products, :institutions ],
      [ :receipts, :institutions ],
      [ :children_groups, :institutions ],
      [ :institution_orders, :institutions ],
      [ :suppliers_packages, :institutions ],
      [ :timesheets, :institutions ],
      [ :menu_requirements, :institutions ],
      [ :supplier_order_products, :institutions ],
      [ :io_corrections, :institution_orders ],
      [ :institution_order_products, :institution_orders ],
      [ :iop_packages, :institution_order_products ],
      [ :io_correction_products, :io_corrections ],
      [ :menu_meals_dishes, :meals ],
      [ :menu_products, :menu_meals_dishes ],
      [ :menu_children_categories, :menu_requirements ],
      [ :menu_meals_dishes, :menu_requirements ],
      [ :menu_products, :menu_requirements ],
      [ :suppliers_packages, :packages ],
      [ :institution_order_products, :products ],
      [ :receipt_products, :products ],
      [ :supplier_order_products, :products ],
      [ :price_products, :products ],
      [ :menu_products, :products ],
      [ :io_correction_products, :products ],
      [ :suppliers_packages, :products ],
      [ :timesheet_dates, :reasons_absences ],
      [ :receipt_products, :receipts ],
      [ :suppliers_packages, :suppliers ],
      [ :supplier_orders, :suppliers ],
      [ :receipts, :supplier_orders ],
      [ :supplier_order_products, :supplier_orders ],
      [ :iop_packages, :suppliers_packages ],
      [ :timesheet_dates, :timesheets ]
    ]

    rename_column :iop_packages, :suppliers_packages_id, :suppliers_package_id

    tables.each { | v |
      remove_foreign_key v[ 0 ], v[ 1 ]
      add_foreign_key v[ 0 ], v[ 1 ], on_delete: :cascade
    }
  end
end
