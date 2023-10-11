CREATE TABLE IF NOT EXISTS inventory.ingredient
(
    id                INTEGER      NOT NULL
        CONSTRAINT pk_ingredient PRIMARY KEY,
    name              VARCHAR(100) NOT NULL,
    ingredienttype_id INTEGER      NOT NULL
);