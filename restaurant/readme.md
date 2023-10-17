# Схема restaurant
#### Таблица Order
Содержит информацию о заказе, поле menu содержит поля food_id, amount, client_wishes
Например:
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
#### Таблица Purchase
Содержит информацию о покупке ингредиентов от поставщика, поле details содержит информацию об ингредиентах
Например:
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