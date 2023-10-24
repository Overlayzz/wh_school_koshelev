# Схема `history`

## **Таблица `ClientChanges`**
##### Используется для логирования информации об изменениях в таблице Client

| Поле            | Тип данных   | Ограничения | Описание                              |
| --------------- | ------------ |-------------| -------------------------------------- |
| log_id          | BIGSERIAL    | NOT NULL    | Уникальный идентификатор записи |
| client_id       | INTEGER      | NOT NULL    | Идентификатор клиента                   |
| card_number     | VARCHAR(16)  | NOT NULL    | Номер карты клиента                     |
| phone           | VARCHAR(11)  | NOT NULL    | Номер телефона клиента                  |
| name            | VARCHAR(200) | NOT NULL    | Имя клиента                            |
| ch_employee_id  | INTEGER      | NOT NULL    | Идентификатор сотрудника, вносящего изменения |
| ch_dt           | TIMESTAMPTZ  | NOT NULL    | Дата и время внесения изменений         |

## **Таблица `EmployeeChanges`**
##### Используется для логирования информации об изменениях в таблице Employee

| Поле            | Тип данных   | Ограничения | Описание                              |
| --------------- | ------------ |-------------| -------------------------------------- |
| log_id          | BIGSERIAL    | NOT NULL    | Уникальный идентификатор записи|
| employee_id     | INTEGER      | NOT NULL    | Идентификатор сотрудника                |
| name            | VARCHAR(200) | NOT NULL    | Имя сотрудника                         |
| phone           | VARCHAR(11)  | NOT NULL    | Номер телефона сотрудника               |
| birth           | DATE         | NOT NULL    | Дата рождения сотрудника                |
| position_id     | INTEGER      | NOT NULL    | Идентификатор должности сотрудника      |
| is_delete       | BOOLEAN      | NOT NULL    | Признак удаления сотрудника             |
| ch_employee_id  | INTEGER      | NOT NULL    | Идентификатор сотрудника, вносящего изменения |
| ch_dt           | TIMESTAMPTZ  | NOT NULL    | Дата и время внесения изменений         |

## **Таблица `OrderChanges`**
##### Используется для логирования информации об изменениях в таблице Order

| Поле            | Тип данных     | Ограничения | Описание                                  |
| --------------- | -------------- |-------------| ------------------------------------------ |
| log_id          | BIGSERIAL      | NOT NULL    | Уникальный идентификатор записи    |
| order_id        | BIGINT         | NOT NULL    | Идентификатор заказа                       |
| total_price     | NUMERIC(15, 2) | NOT NULL    | Общая стоимость заказа                     |
| payment_type    | VARCHAR(20)    | NOT NULL    | Тип оплаты                                |
| menu            | JSONB          | NOT NULL    | JSON-объект с информацией о меню            |
| card_number     | VARCHAR(16)    | NOT NULL    | Номер карты                               |
| desk_id         | INTEGER        | NOT NULL    | Идентификатор столика                      |
| ch_employee_id  | INTEGER        | NOT NULL    | Идентификатор сотрудника, вносящего изменения |
| ch_dt           | TIMESTAMPTZ    | NOT NULL    | Дата и время внесения изменений             |

***Примечания:***
- Поле menu типа JSON описывается в документации схемы `restaurant`

## **Таблица `PurchaseChanges`**
##### Используется для логирования информации об изменениях в таблице Purchase

| Поле            | Тип данных     | Ограничения | Описание                                      |
| --------------- | -------------- |-------------|-----------------------------------------------|
| log_id          | BIGSERIAL      | NOT NULL    | Уникальный идентификатор записи               |
| purchase_id     | INTEGER        | NOT NULL    | Идентификатор закупки                         |
| details         | JSONB          |             | JSON-объект с деталями поставки                |
| supplier_id     | INTEGER        | NOT NULL    | Идентификатор поставщика                      |
| is_approved     | BOOLEAN        | NOT NULL    | Флаг подтверждения поставки                   |
| order_date      | DATE           | NOT NULL    | Дата заказа                                   |
| delivery_date   | DATE           |             | Дата доставки                                 |
| ch_employee_id  | INTEGER        | NOT NULL    | Идентификатор сотрудника, вносящего изменения |
| ch_dt           | TIMESTAMPTZ    | NOT NULL    | Дата и время внесения изменений               |

***Примечания:***
- Поле details типа JSON описывается в документации схемы `restaurant`

## **Функция `PartitionedTables_create`**
Используется для создания партиционных таблиц от текущей даты + 1 год
Пример вызова функции:

```sql
SELECT history.partitionedtables_create();
```
Результат успешного выполнения функции:
```json
{"data": null}
```

## **Функция `PartitionedTables_delete`**
Используется для удаления партиционных таблиц старше (текущей даты минус 3 месяца) по введенному названию таблицы
Пример вызова функции:

```sql
SELECT history.partitionedtables_delete();
```
Результат успешного выполнения функции:
```json
{"data": null}
```