# Схема `restaurant`
## **Таблица `Order`**

##### Используется для хранения заказа клиента

| Поле             | Тип данных     | Ограничения         | Описание                                                     |
| ---------------- | -------------- | ------------------- | ------------------------------------------------------------ |
| order_id         | BIGINT         | NOT NULL            | Уникальный идентификатор заказа.                             |
| total_price      | NUMERIC(15, 2) | NOT NULL            | Общая стоимость заказа.                                      |
| payment_type     | VARCHAR(20)    | NOT NULL            | Тип оплаты заказа.                                           |
| menu             | JSONB          | NOT NULL            | Меню, выбранное для данного заказа.                          |
| card_number      | VARCHAR(16)    | NOT NULL            | Номер карты, использованной для оплаты заказа.               |
| desk_id          | INTEGER        | NOT NULL            | Идентификатор столика, на котором был размещен заказ.         |
| ch_employee_id   | INTEGER        | NOT NULL            | Идентификатор сотрудника, отвечающего за изменение заказа.    |
| ch_dt            | TIMESTAMPTZ    | NOT NULL            | Дата и время изменения заказа.                               |

***Примечания:***
- Логируемая таблица

Поле menu типа JSON содержит следующую информацию:
```json
{
    "items": [
        {
            "food_id": 1,
            "amount": 2,
            "client_wishes": "Без орехов"
        },
        {
            "food_id": 3,
            "amount": 1,
            "client_wishes": "Добавить оливки"
        }
    ]
}
```
- food_id - уникальный идентификатор блюда
- amount - количество порций заказанного блюда
- client_wishes - пожелания клиента к заказанному блюду

## **Таблица `Purchase`**

##### Используется для хранения заказа ингредиентов у поставщика

| Поле             | Тип данных     | Ограничения         | Описание                                                    |
| ---------------- | -------------- | ------------------- |-------------------------------------------------------------|
| purchase_id      | INTEGER        | NOT NULL            | Уникальный идентификатор закупки.                           |
| details          | JSONB          |                     | Детали закупки в формате JSON.                              |
| supplier_id      | INTEGER        | NOT NULL            | Идентификатор поставщика.                                   |
| is_approved      | BOOLEAN        | NOT NULL            | Флаг подтверждения доставки заказа.                         |
| order_date       | DATE           | NOT NULL            | Дата размещения заказа.                                     |
| delivery_date    | DATE           |                     | Дата доставки заказа.                                       |
| ch_employee_id   | INTEGER        | NOT NULL            | Идентификатор сотрудника, отвечающего за изменение закупки. |
| ch_dt            | TIMESTAMPTZ    | NOT NULL            | Дата и время изменения закупки.                             |

***Примечания:***
- Логируемая таблица

Поле details типа JSON содержит следующую информацию:
```json
{
  "order_items": [
    {
      "ingredient_id": 1,
      "amount": 10,
      "price": 2000.00
    },
    {
      "ingredient_id": 2,
      "amount": 5,
      "price": 1000.00
    },
    {
      "ingredient_id": 3,
      "amount": 8,
      "price": 3000.00
    }
  ]
}
```
- ingredient_id - уникальный индентификатор ингредиента
- amount - количество заказанного ингредиента
- price - цена поставщика

## **Функция `Order_upd`**
Пример вызова функции:

```sql
SELECT restaurant.order_upd('
                            {
                              "order_id": "23",
                              "payment_type": "Карта",
                              "menu": [
                                {
                                  "food_id": 20,
                                  "amount": 1,
                                  "client_wishes": ""
                                }
                              ],
                              "card_number": "4248950286742916",
                              "desk_id": "7"
                            }', 1111);
```
***Примечания:***
Если уже существует запись с таким же идентификатором id, то данные заменяются на входящие

Результат успешного выполнения функции:
```json
{"data": null}
```

## **Функция `Purchase_upd`**
Пример вызова функции:

```sql
SELECT restaurant.purchase_upd('
                               {
                                 "purchase_id": 17,
                                 "details": [
                                   {
                                     "ingredient_id":4,
                                     "amount": 20,
                                     "price": 1200.00
                                   }
                                 ],
                                 "supplier_id": "1",
                                 "order_date": "2023-5-14",
                                 "delivery_date": null
                               }', 1111);
```
***Примечания:***
* Если уже существует запись с таким же идентификатором id, то данные заменяются на входящие.
* В случае если при вводе данных поле delivery_date != null, то в таблицу запишется дата доставки и поменяется флаг is_approved на true;

Результат успешного выполнения функции:
```json
{"data": null}
```

## **Функция `order_getinfo`**
Пример вызова функции:

```sql
select restaurant.order_getinfo(NULL,NULL,1);
```
***Примечания:***
* Присутствуют фильтры для полей: order_id, card_number, desk_id

Результат успешного выполнения функции:
```json
{
  "data": [
    {
      "menu": [
        {
          "amount": 2,
          "food_id": 1,
          "client_wishes": ""
        }
      ],
      "desk_id": 1,
      "order_id": 2,
      "card_number": "4248950286742912",
      "total_price": 1900,
      "payment_type": "Карта"
    },
    {
      "menu": [
        {
          "amount": 1,
          "food_id": 1,
          "client_wishes": ""
        }
      ],
      "desk_id": 1,
      "order_id": 3,
      "card_number": "4248950286742912",
      "total_price": 950,
      "payment_type": "Карта"
    }   
  ]
}
```

## **Функция `purchase_getinfo`**
Пример вызова функции:

```sql
select restaurant.purchase_getinfo(NULL,NULL,TRUE);
```
***Примечания:***
* Присутствуют фильтры для полей: purchase_id, supplier_id, is_approved

Результат успешного выполнения функции:
```json
{
  "data": [
    {
      "details": [
        {
          "price": 2000,
          "amount": 29,
          "ingredient_id": 1
        },
        {
          "price": 1000,
          "amount": 5,
          "ingredient_id": 2
        }
      ],
      "order_date": "2023-09-15",
      "is_approved": true,
      "purchase_id": 1,
      "supplier_id": 1,
      "delivery_date": "2023-10-18"
    }
  ]
}
```

