# Схема inventory
#### Таблица Desk
Содержит данные о столах: свободен или занят стол и его местоположение
#### Таблица Food
Содержит меню ресторана, использует при формировании заказа.
Поле ingredients типа JSONB содержит информацию об ингредиентах(ingredient_id, ingredient_name, ingredient_weight)
Например:
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