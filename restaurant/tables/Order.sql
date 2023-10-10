CREATE TABLE IF NOT EXISTS restaurant.order
(
    id            BIGINT         NOT NULL
        CONSTRAINT pk_order PRIMARY KEY,
    ch_dt         TIMESTAMPTZ    NOT NULL,
    total_price   NUMERIC(15, 2) NOT NULL,
    payment_type  VARCHAR(20)    NOT NULL,
    client_wishes JSONB,
    assortment_id INTEGER        NOT NULL,
    client_id     INTEGER        NOT NULL,
    employee_id   INTEGER        NOT NULL,
    desk_id       INTEGER        NOT NULL
);
