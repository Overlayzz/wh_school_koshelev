CREATE TABLE IF NOT EXISTS restaurant.purchase
(
    id            INTEGER     NOT NULL
        CONSTRAINT pk_purchase PRIMARY KEY,
    details       JSONB,
    supplier_id   INTEGER     NOT NULL,
    is_approved   BOOLEAN     NOT NULL,
    order_date    DATE        NOT NULL,
    delivery_date DATE,
    employee_id   INTEGER     NOT NULL,
    ch_dt         TIMESTAMPTZ NOT NULL
);