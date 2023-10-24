# Схема `inventory`
## **Таблица `Desk`**
##### Используется для хранения информации о столах

| Поле           | Тип данных   | Ограничения | Описание                                                 |
| -------------- | ------------ | ----------- | -------------------------------------------------------- |
| desk_id        | SMALLINT     | NOT NULL    | Уникальный идентификатор стола               |
| table_number   | SMALLINT     | NOT NULL    | Номер стола                                              |
| seat_count     | SMALLINT     | NOT NULL    | Количество посадочных мест на столе                       |
| is_reservation | BOOLEAN      | NOT NULL    | Флаг, указывающий, зарезервирован ли стол                  |
| location       | VARCHAR(100) |             | Местоположение стола                                     |

## **Таблица `Food`**
##### Используется для хранения информации о позициях в меню

| Поле         | Тип данных   | Ограничения | Описание                                       |
| ------------ | ------------ | ----------- | ---------------------------------------------- |
| food_id      | INTEGER      | NOT NULL    | Уникальный идентификатор продукта  |
| name         | VARCHAR(100) | NOT NULL    | Название продукта                              |
| weight       | INTEGER      | NOT NULL    | Вес продукта в граммах                          |
| price        | NUMERIC(15, 2) | NOT NULL   | Цена продукта                                  |
| ingredients  | JSONB        | NOT NULL    | Ингредиенты, составляющие продукт               |
| is_delete    | BOOLEAN      | NOT NULL    | Флаг, указывающий, удален ли продукт            |
| foodtype_id  | INTEGER      | NOT NULL    | Идентификатор типа продукта                     |

***Примечания:***
Поле ingredients типа JSON содержит следующую информацию:

```json
{
    "ingredients": [
        {
            "ingredient_id": 1,
            "ingredient_name": "Мокровь",
            "weight": 25
        },
        {
            "ingredient_id": 3,
            "ingredient_name": "Огурец",
            "weight": 40
        }
    ]
}
```
- ingredient_id - уникальный идентификатор ингредиента
- ingredient_name - название ингредиента
- weight - вес ингредиента

## **Функция `Desk_upd`**
Пример вызова функции:

```sql
SELECT inventory.desk_upd('[
  {
    "desk_id": "18",
    "table_number": "4",
    "seat_count": "8",
    "is_reservation": "false",
    "location": "Центральная часть зала"
  }
]');
```
***Примечания:***
Если уже существует запись с таким же идентификатором id и номером стола table_number, то данные заменяются на входящие

Результат успешного выполнения функции:
```json
{"data": null}
```

## **Функция `Food_upd`**
Пример вызова функции:

```sql
SELECT inventory.food_upd('[
  {
    "name": "Амдурьинская уха",
    "weight": "500",
    "price": "580.00",
    "ingredients": [
      {
        "ingredient_id": 1,
        "ingredient_name": "Лук репчатый",
        "weight": 33
      },
      {
        "ingredient_id": 4,
        "ingredient_name": "Курица",
        "weight": 60
      },
      {
        "ingredient_id": 5,
        "ingredient_name": "Гречневая лапша",
        "weight": 55
      }
    ],
    "is_delete": "false",
    "foodtype_id": "3"
  }
]');
```
***Примечания:***
Если уже существует запись с таким же идентификатором id и номером стола table_number, то данные заменяются на входящие

Результат успешного выполнения функции:
```json
{"data": null}
```

## **Функция `Food_getInfo`**
Пример вызова функции:

```sql
select inventory.food_getinfo(20, NULL, NULL);
```
***Примечания:***
* Присутствуют фильтры для полей: food_id, foodtype_id, is_delete

Результат успешного выполнения функции:
```json
{
  "data": [
    {
      "name": "Амдурьинская уха",
      "price": 580,
      "weight": 500,
      "food_id": 20,
      "is_delete": false,
      "foodtype_id": 3,
      "ingredients": [
        {
          "weight": 33,
          "ingredient_id": 1,
          "ingredient_name": "Лук репчатый"
        },
        {
          "weight": 60,
          "ingredient_id": 4,
          "ingredient_name": "Курица"
        },
        {
          "weight": 55,
          "ingredient_id": 5,
          "ingredient_name": "Гречневая лапша"
        }
      ]
    }
  ]
}
```

## **Функция `Desk_getInfo`**
Пример вызова функции:

```sql
select inventory.desk_getinfo(6, NULL);
```
***Примечания:***
* Присутствуют фильтры для полей: desk_id, is_reservation

Результат успешного выполнения функции:
```json
{
  "data": [
    {
      "desk_id": 6,
      "location": "Левая часть зала",
      "seat_count": 2,
      "table_number": 2,
      "is_reservation": true
    }
  ]
}
```