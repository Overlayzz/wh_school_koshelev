CREATE TABLE IF NOT EXISTS dictionary.ingredient
(
    ingredient_id     SMALLSERIAL  NOT NULL
        CONSTRAINT pk_ingredient PRIMARY KEY,
    name              VARCHAR(100) NOT NULL,
    ingredienttype_id INTEGER      NOT NULL
);