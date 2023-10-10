CREATE TABLE IF NOT EXISTS inventory.ingredient
(
    id                INTEGER        NOT NULL
        CONSTRAINT pk_ingredient PRIMARY KEY,
    name              VARCHAR(100)   NOT NULL,
    price             NUMERIC(15, 2) NOT NULL,
    amount            SMALLINT       NOT NULL,
    supplier_id       SMALLSERIAL    NOT NULL,
    ingredienttype_id SMALLSERIAL    NOT NULL
);