CREATE TABLE IF NOT EXISTS inventory.food
(
    id            INTEGER        NOT NULL
        CONSTRAINT pk_food PRIMARY KEY,
    name          VARCHAR(100)   NOT NULL,
    ingredients   VARCHAR(300)   NOT NULL,
    weight        INTEGER        NOT NULL,
    price         NUMERIC(15, 2) NOT NULL,
    ingredient_id INTEGER        NOT NULL,
    foodtype_id   INTEGER        NOT NULL
);