CREATE TABLE IF NOT EXISTS restaurant.purchase
(
    id            INTEGER     NOT NULL
        CONSTRAINT pk_purchase PRIMARY KEY,
    amount        INTEGER     NOT NULL,
    ch_dt         TIMESTAMPTZ NOT NULL,
    ingredient_id INTEGER     NOT NULL,
    supplier_id   INTEGER     NOT NULL
);