CREATE TABLE IF NOT EXISTS restaurant.assortment
(
    id       INTEGER NOT NULL
        CONSTRAINT pk_assortment PRIMARY KEY,
    food_id  INTEGER NOT NULL,
    amount INTEGER NOT NULL
);