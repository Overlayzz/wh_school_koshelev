CREATE TABLE IF NOT EXISTS sklad.sales
(
    id         INTEGER     NOT NULL,
    date       TIMESTAMPTZ NOT NULL,
    client_id  INTEGER     NOT NULL,
    product_id INTEGER     NOT NULL,
    quantity   INTEGER     NOT NULL,
    CONSTRAINT PK_prod PRIMARY KEY (id),
    CONSTRAINT ch_kol CHECK (quantity > 0)
);