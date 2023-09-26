CREATE TABLE IF NOT EXISTS sklad.product
(
    id    INTEGER        NOT NULL,
    name  VARCHAR(30)    NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    CONSTRAINT PK_Product PRIMARY KEY (id),
    CONSTRAINT ch_price CHECK (price > 0)
);