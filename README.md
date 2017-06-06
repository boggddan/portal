# API

## *Зміст*
- [Введення](#Введення-top)
- [Довідники](#Довідники-top)
  - [*Установи* - `branches`](#Установи---branches-top)
  - [*Підрозділи* - `institutions`](#Підрозділи---institutions-top)
  - [*Продукти харчування* - `products`](#Продукти-харчування---products-top)
  - [*Типи продуктів харчування* - `products_types`](#Типи-продуктів-харчування---products_types-top)
  - [*Упаковки* - `packages`](#Упаковки---packages-top)
  - [*Упаковки постачальників* - `suppliers_packages`](#Упаковки-постачальників---suppliers_packages-top)
  - [*Постачальники* - `suppliers`](#Постачальники---suppliers-top)
  - [*Ціни на продукти* - `price_products`](#Ціни-на-продукти---price_products-top)
  - [*Планова вартість дітодня* - `children_day_costs`](#Планова-вартість-дітодня---children_day_costs-top)
  - [*Причини відмови поставки* - `causes_deviations`](#Причини-відмови-поставки---causes_deviations-top)
  - [*Діти* - `children`](#Діти---children-top)
  - [*Категорії дітей* - `children_categories`](#Категорії-дітей---children_categories-top)
  - [*Групи дітей* - `children_groups`](#Групи-дітей---children_groups-top)
  - [*Типи категорії дітей* - `children_categories_types`](#Типи-категорії-дітей---children_categories_types-top)
  - [*Причини відсутності дитини* - `reasons_absences`](#Причини-відсутності-дитини---reasons_absences-top)
- [Документи](#Документи-top)
  - [*Замовлення постачальнику* - `supplier_orders`](#Замовлення-постачальнику---supplier_orders-top)
  - [*Надходження ТМЦ* - `receipts`](#Надходження-ТМЦ---receipts-top)
  - [*Замовлення продуктів харчування* - `institution_orders`](#Замовлення-продуктів-харчування---institution_orders-top)
  - [*Коректування замовлення продуктів харчування* - `io_corrections`](#Коректування-замовлення-продуктів-харчування---io_corrections-top)
  - [*Меню-вимога* - `menu_requirements`](#Меню-вимога---menu_requirements-top)
  - [*Табель* - `timesheets`](#Табель---timesheets-top)

## Введення [:top:](#Зміст)
Рекомендуєма программа для роботи з API - [**Postman**](https://www.getpostman.com/)

**Стуктура наведених запитів**

POST | /api/cu_supplier | { "code": "25", "name": "ТОВ Постач № 25" } 
-|-|-
Тип запиту | суфікс до адреси серверу | Тіло запиту

![postman_post](https://user-images.githubusercontent.com/24915025/26839046-8f3d7ef0-4aea-11e7-8a11-bd246f5c2aa2.png)

Запит | Опис
-|-
GET | Отримання данних. Вказано в множині (закінчення на `-s(-es)`), **параметрів не потрібно** - `даний запит повертає всі дані. Наприклад `GET /api/cu_suppliers`
POST | Коригування данних
DELETE | Видалення даних

## Довідники [:top:](#Зміст)
### *Установи* - `branches` [:top:](#Зміст)
```
  POST /api/cu_institution { "code": "14", "name": "18 (ДОУ)", "prefix": "Д18", "branch_code": "00000000003" }
  GET /api/institution?code=14
  GET /api/institutions
```

### *Підрозділи* - `institutions` [:top:](#Зміст)
```
  POST /api/cu_institution { "code": "14", "name": "18 (ДОУ)", "prefix": "Д18", "branch_code": "00000000003" }
  GET /api/institution?code=14
  GET /api/institutions

```

### *Продукти харчування* - `products` [:top:](#Зміст)
```
  POST /api/cu_product { "code": "00000000079", "name": "Баклажани", "products_type_code": "000000001" }
  GET /api/product?code=000000079
  GET /api/products
```

### *Типи продуктів харчування* - `products_types` [:top:](#Зміст)
```
  POST /api/cu_products_type { "code": "000000001", "name": "Вироби з молока", "priority": 1 }
  GET /api/products_type?code=000000001
  GET /api/products_types
```

### *Упаковки* - `packages` [:top:](#Зміст)
```
  POST /api/cu_package { "code": "000000001", "name": "Сітка 5 кг", "conversion_factor": 5.000000 }
  GET /api/package?code=000000001
  GET /api/packages
```

### *Упаковки постачальників* - `suppliers_packages` [:top:](#Зміст)
```
  POST /api/cu_suppliers_package { "institution_code": "14", "supplier_code": "8", "product_code": "00000000079", "package_code": "000000001", "period": "1496448000", "activity": 1 }
  GET /api/suppliers_package?institution_code=14&supplier_code=8&product_code=00000000079&package_code=000000001&period=2017-05-03
  GET /api/suppliers_packages
```

### *Постачальники* - `suppliers` [:top:](#Зміст)
```
  POST /api/cu_supplier { "code": "25", "name": "ТОВ Постач № 25" }
  GET /api/supplier?code=16
  GET /api/suppliers

```

### *Ціни на продукти* - `price_products` [:top:](#Зміст)
```
  POST /api/cu_price_product { "branch_code": "0003", "institution_code": "14", "product_code": "000000079  ", "price_date": "1485296673", "price": 30.25  }
  GET /api/price_product?branch_code=0003&institution_code=14&product_code=000000079&price_date=2017-01-25
  GET /api/price_products

```

### *Планова вартість дітодня* - `children_day_costs` [:top:](#Зміст)
```
  POST /api/cu_children_day_cost { "children_category_code": "000000001", "cost_date": "1485296673", "cost": 12.25 }
  GET /children_day_cost?children_category_code=000000001&cost_date=2017-01-25
  GET api/children_day_costs

```

### *Причини відмови поставки* - `causes_deviations` [:top:](#Зміст)
```
  POST /api/cu_causes_deviation { "code": "000000002", "name": "Причина 2" }
  GET /api/causes_deviation?code=000000002
  GET /api/causes_deviations
```

### *Діти* - `children` [:top:](#Зміст)
```
  POST /api/cu_child { "code": "000000001", "name": "Іванов Іван Іванович" }
  GET /api/child?code=000000001
  GET /api/children
```

### *Категорії дітей* - `children_categories` [:top:](#Зміст)
```
  POST /api/cu_children_category { "code": "00000001", "name": "Яслі", "children_categories_type_code": "00000001" }
  GET /api/children_category?code=000000003
  GET /api/children_categories
```

### *Групи дітей* - `children_groups` [:top:](#Зміст)
```
  POST /api/cu_children_group { "code": "000000003", "name": "3\1", "children_category_code": "000000001", "institution_code": "14"}
  GET /api/children_group?code=000000003
  GET /api/children_groups
```

### *Типи категорії дітей* - `children_categories_types` [:top:](#Зміст)
```
  POST /api/cu_children_categories_type { "code": "00000001", "name": "Дошкільний" }
  GET /api/children_categories_type?code=16
  GET /api/children_categories_types
```

### *Причини відсутності дитини* - `reasons_absences` [:top:](#Зміст)
```
  POST /api/cu_reasons_absence { "code": "000000001", "mark": "Х", "name": "Хвороба" }
  GET /api/reasons_absence?code=000000001
  GET /api/reasons_absences
```

## Документи [:top:](#Зміст)
### *Замовлення постачальнику* - `supplier_orders` [:top:](#Зміст)
```
  POST /api/cu_supplier_order { "branch_code": "00000000006", "supplier_code": "00000000023", "number": "00000011", "date": 1495542284, "date_start": 1498867200, "date_end": 1519862400, "products": [ { "institution_code": "14", "product_code": "000000079", "contract_number": "BX-0000001", "date": 1495542284, "count": 12, "price": 10.05}, {"institution_code": "14", "product_code": "000000046  ", "contract_number": "BX-0000001", "date": 1495628684, "count": 15, "price": 17.12 } ] }
  GET api/supplier_order?supplier_order?branch_code=0003&number=00000011
  DELETE api/supplier_order { "branch_code": "00000000003", "number": "000000000002" }
```

### *Надходження ТМЦ* - `receipts` [:top:](#Зміст)
```
  POST /api/cu_receipt { "institution_code": "14", "supplier_order_number": "000000000002", "contract_number": "Ис-000000001", "number": "0000000000011", "invoice_number": "00000012", "date": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001", "products": [ { "product_code": "000000079", "date": "1504224000", "count": 25, "count_invoice": 25, "causes_deviation_code": "" }, { "product_code": "000000046", "date": "1504224000", "count": 19, "count_invoice": 30, "causes_deviation_code": "000000002" } ] }
  GET /api/receipt?/receipt?institution_code=14&number=KL-000000005
  DELETE /api/receipt { "institution_code": "14", "number": "000000000002" }
```

### *Замовлення продуктів харчування* - `institution_orders` [:top:](#Зміст)
```
  POST /api/cu_institution_order { "institution_code": "14", "number": "000000000002", "date": "1485296673", "date_start": "1485296673", "date_end": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001", "products": [ { "date": "1485296673", "product_code": "000000079  ", "count": 15, "description": "1 тиждень"}, { "date": "1485296673", "product_code": "000000048  ", "count": 15, "description": "1 тиждень,3 тиждень" } ] }
  GET api/institution_order?institution_code=14&number=000000000002
  DELETE api/institution_order { "institution_code": "14", "number": "000000000002" }
```

### *Коректування замовлення продуктів харчування* - `io_corrections` [:top:](#Зміст)
```
  POST /api/cu_institution_order_correction { "institution_code": "14", "institution_order_number": "000000000002", "number": "000000000004", "date": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001", "products": [ { "date": "1485296673", "product_code": "000000079", "diff": 7, "description": "1 тиждень" }, { "date": "1485296673", "product_code": "000000048  ", "diff": 5, "description": "1 тиждень,3 тиждень" } ] }
  GET /api/institution_order_correction?institution_code=14&institution_order_number=000000000002&number=000000000010
  DELETE /api/institution_order_correction { "institution_code": "14", "institution_order_number": "KL-000000024", "number": "KL-000000011" }

```

### *Меню-вимога* - `menu_requirements` [:top:](#Зміст)
- План
```
  POST /api/cu_menu_requirement_plan { "branch_code": "0003", "institution_code": "14", "number": "000000000002", "date": "1485296673", "splendingdate": "1485296673", "date_sap": "1485296673", "number_sap": "000000000001", "children_categories": [ { "children_category_code": "000000001", "count_all_plan": 55, "count_exemption_plan": 19 }, { "children_category_code": "000000002", "count_all_plan": 3, "count_exemption_plan": 7 } ], "products": [ { "children_category_code": "000000001", "product_code": "000000079  ", "count_plan": 15 }, { "children_category_code": "000000002", "product_code": "000000079  ", "count_plan": 21 } ] }
```
- Факт
```
  POST /api/cu_menu_requirement_fact { "branch_code": "0003", "institution_code": "14", "number": "000000000002", "date": "1485296673", "splendingdate": "1485296673", "date_saf": "1485296673", "number_saf": "000000000001", "children_categories": [ { "children_category_code": "000000001", "count_all_fact": 55, "count_exemption_fact": 19 }, { "children_category_code": "000000002", "count_all_fact": 3, "count_exemption_fact": 7 } ], "products": [ { "children_category_code": "000000001", "product_code": "000000079  ", "count_fact": 15 }, { "children_category_code": "000000002", "product_code": "000000079  ", "count_fact": 21 } ] }
```
- Загальні
```
  GET api/menu_requirement?institution_code=14&number=000000000028
  DELETE api/menu_requirement { "institution_code": "14", "number": "000000000002" }
```
### *Табель* - `timesheets` [:top:](#Зміст)
```
  POST /api/cu_timesheet { "branch_code": "0003", "institution_code": "14", "number": "000000000002", "date": "1487548800", "date_vb": "1485907200", "date_ve": "1488240000", "date_eb": "1485907200", "date_ee": "1486684800", "date_sa": "1506902400", "number_sa": "000000000001", "dates": [ { "child_code": "000000001", "children_group_code": "000000001", "reasons_absence_code": "000000001", "date": "1485907200" }, { "child_code": "000000001", "children_group_code": "000000001", "reasons_absence_code": "000000001", "date": "1485993600" } ] }
  GET api/timesheet?institution_code=14&number=000000000001
  DELETE api/timesheet { "institution_code": "14", "number": "000000000002" }
```