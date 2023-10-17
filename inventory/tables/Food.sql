CREATE TABLE IF NOT EXISTS inventory.food
(
    food_id        INTEGER        NOT NULL
        CONSTRAINT pk_food PRIMARY KEY,
    name           VARCHAR(100)   NOT NULL,
    weight         INTEGER        NOT NULL,
    price          NUMERIC(15, 2) NOT NULL,
    ingredients    JSONB          NOT NULL,
    is_delete      BOOLEAN        NOT NULL,
    foodtype_id    INTEGER        NOT NULL
);