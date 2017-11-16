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
  - [*Планова вартість дітодня* - `children_day_costs`](#Планова-вартість-дітодня---children_day_costs-top)
  - [*Причини відмови поставки* - `causes_deviations`](#Причини-відмови-поставки---causes_deviations-top)
  - [*Діти* - `children`](#Діти---children-top)
  - [*Категорії дітей* - `children_categories`](#Категорії-дітей---children_categories-top)
  - [*Групи дітей* - `children_groups`](#Групи-дітей---children_groups-top)
  - [*Типи категорії дітей* - `children_categories_types`](#Типи-категорії-дітей---children_categories_types-top)
  - [*Причини відсутності дитини* - `reasons_absences`](#Причини-відсутності-дитини---reasons_absences-top)
  - [*Категорії страв* - `dishes_categories`](#Категорії-страв---dishes_categories-top)
  - [*Страви* - `dishes`](#Страви---dishes-top)
  - [*Прийоми їжі* - `meals`](#Прийоми-їжі---meals-top)
  - [*Норми продуктів підрозділу по категоріях дітей в стравах* - `dishes_products_norms`](#Норми-продуктів-підрозділу-по-категоріях-дітей-в-стравах---dishes_products_norms-top)
  - [*Дата блокування документів* - `date_blocks`](#Дата-блокування-документів---date_blocks-top)
- [Документи](#Документи-top)
  - [*Замовлення постачальнику* - `supplier_orders`](#Замовлення-постачальнику---supplier_orders-top)
  - [*Надходження ТМЦ* - `receipts`](#Надходження-ТМЦ---receipts-top)
  - [*Замовлення продуктів харчування* - `institution_orders`](#Замовлення-продуктів-харчування---institution_orders-top)
  - [*Коригування замовлення продуктів харчування* - `io_corrections`](#Коригування-замовлення-продуктів-харчування---io_corrections-top)
  - [*Меню-вимога* - `menu_requirements`](#Меню-вимога---menu_requirements-top)
  - [*Табель* - `timesheets`](#Табель---timesheets-top)

## Введення [:top:](#Зміст)

Рекомендуєма программа для роботи з API - [**Postman**](https://www.getpostman.com/)

**Стуктура наведених запитів:**

POST | /api/cu_supplier | { "code": "25", "name": "ТОВ Постач № 25" }
-|-|-
Тип запиту | суфікс до адреси серверу | Тіло запиту

![postman_post](https://user-images.githubusercontent.com/24915025/26839046-8f3d7ef0-4aea-11e7-8a11-bd246f5c2aa2.png)

Запит | Опис
-|-
GET | Отримання данних. Вказано в множині (закінчення на `-s(-es)`), **параметрів не потрібно** - даний запит повертає всі дані. Наприклад `GET /api/cu_suppliers`.
POST | Коригування данних
DELETE | Видалення даних (`"type": 0` фізично видаляє запис з таблиці )

## Довідники [:top:](#Зміст)

### *Установи* - `branches` [:top:](#Зміст)

```json
POST /api/cu_institution { "code": "14", "name": "18 (ДОУ)", "prefix": "Д18", "branch_code": "00000000003" }
GET /api/institution?code=14
GET /api/institutions
```

### *Підрозділи* - `institutions` [:top:](#Зміст)

```json
POST /api/cu_institution { "code": "14", "name": "18 (ДОУ)", "prefix": "Д18", "branch_code": "00000000003" }
GET /api/institution?code=14
GET /api/institutions
```

### *Продукти харчування* - `products` [:top:](#Зміст)

```json
POST /api/cu_product { "code": "00000000079", "name": "Баклажани", "products_type_code": "000000001" }
GET /api/product?code=000000079
GET /api/products
```

### *Типи продуктів харчування* - `products_types` [:top:](#Зміст)

```json
POST /api/cu_products_type { "code": "000000001", "name": "Вироби з молока", "priority": 1 }
GET /api/products_type?code=000000001
GET /api/products_types
```

### *Упаковки* - `packages` [:top:](#Зміст)

```json
POST /api/cu_package { "code": "000000001", "name": "Сітка 5 кг", "conversion_factor": 5.000000 }
GET /api/package?code=000000001
GET /api/packages
```

### *Упаковки постачальників* - `suppliers_packages` [:top:](#Зміст)

```json
POST /api/cu_suppliers_package { "institution_code": "14", "supplier_code": "8", "product_code": "00000000079", "package_code": "000000001", "period": "1496448000", "activity": 1 }
GET /api/suppliers_package?institution_code=14&supplier_code=8&product_code=00000000079&package_code=000000001&period=2017-05-03
GET /api/suppliers_packages
```

### *Постачальники* - `suppliers` [:top:](#Зміст)

```json
POST /api/cu_supplier { "code": "25", "name": "ТОВ Постач № 25" }
GET /api/supplier?code=16
GET /api/suppliers
```

### *Планова вартість дітодня* - `children_day_costs` [:top:](#Зміст)

```json
POST /api/cu_children_day_cost { "children_category_code": "000000001", "cost_date": "1485296673", "cost": 12.25 }
GET /children_day_cost?children_category_code=000000001&cost_date=2017-01-25
GET api/children_day_costs
```

### *Причини відмови поставки* - `causes_deviations` [:top:](#Зміст)

```json
  POST /api/cu_causes_deviation { "code": "000000002", "name": "Причина 2" }
  GET /api/causes_deviation?code=000000002
  GET /api/causes_deviations
```

### *Діти* - `children` [:top:](#Зміст)

```json
POST /api/cu_child { "code": "000000001", "name": "Іванов Іван Іванович" }
GET /api/child?code=000000001
GET /api/children
```

### *Категорії дітей* - `children_categories` [:top:](#Зміст)

```json
POST /api/cu_children_category { "code": "000000001", "name": "Яслі", "priority": 1, "children_categories_type_code": "000000001" }
GET /api/children_category?code=000000001
GET /api/children_categories
```

### *Групи дітей* - `children_groups` [:top:](#Зміст)

```json
POST /api/cu_children_group { "code": "000000003", "name": "3\1", "children_category_code": "000000001", "institution_code": "14"}
GET /api/children_group?code=000000003
GET /api/children_groups
```

### *Типи категорії дітей* - `children_categories_types` [:top:](#Зміст)

```json
POST /api/cu_children_categories_type { "code": "00000001", "name": "Дошкільний" }
GET /api/children_categories_type?code=16
GET /api/children_categories_types
```

### *Причини відсутності дитини* - `reasons_absences` [:top:](#Зміст)

```json
POST /api/cu_reasons_absence { "code": "000000001", "mark": "Х", "name": "Хвороба" }
GET /api/reasons_absence?code=000000001
GET /api/reasons_absences
```

### *Категорії страв* - `dishes_categories` [:top:](#Зміст)

```json
POST /api/cu_dishes_categories { "dishes_categories": [ { "code": "000000001", "name": "Перша страва", "priority": 1 }, { "code": "000000002", "name": "Друга страва", "priority": 2 } ] }
GET /api/dishes_category?code=000000002
GET /api/dishes_categories
```

### *Страви* - `dishes` [:top:](#Зміст)

```json
POST /api/cu_dishes { "dishes": [ { "code": "000000003", "name": "Суп", "dishes_category_code": "000000001", "priority": 4 }, { "code": "000000004", "name": "Чай", "dishes_category_code": "000000002", "priority": 3 } ] }
GET /api/dish?code=000000001
GET /api/dishes
```

### *Прийоми їжі* - `meals` [:top:](#Зміст)

```json
POST /api/cu_meals { "meals": [ { "code": "000000001", "name": "Сніданок", "priority": 1 }, { "code": "000000002", "name": "Обід", "priority": 2 } ] }
GET /api/meal?code=000000002
GET /api/meals
```

### *Норми продуктів підрозділу по категоріях дітей в стравах* - `dishes_products_norms` [:top:](#Зміст)

```json
POST /api/cu_dishes_products_norms
{ "dishes_products_norms":
  [
    { "institution_code": 14, "dish_code": "000000002", "product_code": "000000054", "children_category_code": "000000001", "amount": 0.01 },
    { "institution_code": 14, "dish_code": "000000002", "product_code": "000000047", "children_category_code": "000000001", "amount": 0.05 }
  ]
}
```

### *Дата блокування документів* - `date_blocks` [:top:](#Зміст)

```json
  POST /api/cu_date_blocks
  { "date_blocks":
    [
      { "institution_code": 14, "date_start": 1509494400, "date_end": 1510576706 }
    ]
  }

  DELETE /api/date_blocks
  { "date_blocks":
    [
      { "institution_code": 14, "date_start": 1509494400, "date_end": 1510576706 }
    ]
  }
```

## Документи [:top:](#Зміст)

### *Замовлення постачальнику* - `supplier_orders` [:top:](#Зміст)

```json
POST /api/cu_supplier_order { "branch_code": "00000000006", "supplier_code": "00000000023", "number": "ІС000000001", "date": 1504001724, "date_start": 1498867200, "date_end": 1519862400, "products": [ { "institution_code": "14", "product_code": "000000079", "contract_number": "BX-0000001", "contract_number_manual": "РР000000001", "date": 1495542284, "count": 12, "price": 10.05}, {"institution_code": "14", "product_code": "000000046  ", "contract_number": "BX-0000001", "contract_number_manual": "", "date": 1495628684, "count": 15, "price": 17.12 } ] }
GET api/supplier_order?supplier_order?branch_code=0003&number=00000011
DELETE api/supplier_order { "branch_code": "00000000003", "number": "000000000006", "type": 1 }
```

### *Надходження ТМЦ* - `receipts` [:top:](#Зміст)

```json
POST /api/cu_receipt { "institution_code": "14", "supplier_order_number": "000000000002", "contract_number": "Ис-000000001", "number": "0000000000011", "invoice_number": "00000012", "date": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001", "products": [ { "product_code": "000000079", "date": "1504224000", "count": 25, "count_invoice": 25, "causes_deviation_code": "" }, { "product_code": "000000046", "date": "1504224000", "count": 19, "count_invoice": 30, "causes_deviation_code": "000000002" } ] }
GET /api/receipt?/receipt?institution_code=14&number=KL-000000005
DELETE /api/receipt { "institution_code": "14", "number": "000000000002" }
```

### *Замовлення продуктів харчування* - `institution_orders` [:top:](#Зміст)

```json
POST /api/cu_institution_order { "institution_code": "14", "number": "000000000002", "date": "1485296673", "date_start": "1485296673", "date_end": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001", "products": [ { "date": "1485296673", "product_code": "000000079  ", "count": 15, "description": "1 тиждень"}, { "date": "1485296673", "product_code": "000000048  ", "count": 15, "description": "1 тиждень,3 тиждень" } ] }
GET api/institution_order?institution_code=14&number=000000000002
DELETE api/institution_order { "institution_code": "14", "number": "KL-000000013", "type": 1 }
```

### *Коригування замовлення продуктів харчування* - `io_corrections` [:top:](#Зміст)

```json
POST /api/cu_institution_order_correction { "institution_code": "14", "institution_order_number": "KL-000000058", "number": "000000000004", "date": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001",
"products": [ { "date": "1485296673", "product_code": "000000079  ", "amount_order": 5, "amount": 7, "description": "1 тиждень" }, { "date": "1485296673", "product_code": "000000048  ", "amount_order": 8, "amount": 8, "description": "1 тиждень,3 тиждень" } ] }
GET /api/institution_order_correction?institution_code=14&institution_order_number=000000000002&number=000000000010
DELETE /api/institution_order_correction { "institution_code": "14", "institution_order_number": "KL-000000053", "number": "KL-000000022",  "type": 1 }
```

### *Меню-вимога* - `menu_requirements` [:top:](#Зміст)

- План

```json
POST /api/cu_menu_requirement_plan { "branch_code": "0003", "institution_code": "14", "number": "000000000002", "date": "1485296673", "splendingdate": "1485296673", "date_sap": "1485296673", "number_sap": "000000000001", "children_categories": [ { "children_category_code": "000000001", "count_all_plan": 55, "count_exemption_plan": 19 }, { "children_category_code": "000000002", "count_all_plan": 3, "count_exemption_plan": 7 } ], "products": [ { "children_category_code": "000000001", "product_code": "000000079  ", "count_plan": 15 }, { "children_category_code": "000000002", "product_code": "000000079  ", "count_plan": 21 } ] }

DELETE api/menu_requirement { "institution_code": "14", "number": "KL-000000024", "type": 1 }
```

- Факт

```json
POST /api/cu_menu_requirement_fact { "branch_code": "0003", "institution_code": "14", "number": "000000000002", "date": "1485296673", "splendingdate": "1485296673", "date_saf": "1485296673", "number_saf": "000000000001", "children_categories": [ { "children_category_code": "000000001", "count_all_fact": 55, "count_exemption_fact": 19 }, { "children_category_code": "000000002", "count_all_fact": 3, "count_exemption_fact": 7 } ], "products": [ { "children_category_code": "000000001", "product_code": "000000079  ", "count_fact": 15 }, { "children_category_code": "000000002", "product_code": "000000079  ", "count_fact": 21 } ] }

DELETE api/menu_requirement { "institution_code": "14", "number": "KL-000000024", "type": 2 }
```

- Перегляд документа

```json
  GET api/menu_requirement?institution_code=14&number=000000000028
```

- Друк документа

```json
  GET /api/print_menu_requirement?institution_code=14&number=018В-0000121
```

### *Табель* - `timesheets` [:top:](#Зміст)

```json
POST /api/cu_timesheet { "branch_code": "0003", "institution_code": "14", "number": "000000000002", "date": "1487548800", "date_vb": "1485907200", "date_ve": "1488240000", "date_eb": "1485907200", "date_ee": "1486684800", "date_sa": "1506902400", "number_sa": "000000000001", "dates": [ { "child_code": "000000001", "children_group_code": "000000001", "reasons_absence_code": "000000001", "date": "1485907200" }, { "child_code": "000000001", "children_group_code": "000000001", "reasons_absence_code": "000000001", "date": "1485993600" } ] }
GET api/timesheet?institution_code=14&number=000000000001
DELETE api/timesheet { "institution_code": "14", "number": "KL-000000028", "type": 1 }
```
