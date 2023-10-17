CREATE TABLE IF NOT EXISTS restaurant.order
(
    order_id       BIGINT         NOT NULL
        CONSTRAINT pk_order PRIMARY KEY,
    total_price    NUMERIC(15, 2) NOT NULL,
    payment_type   VARCHAR(20)    NOT NULL,
    menu           JSONB          NOT NULL,
    card_number    VARCHAR(16)    NOT NULL,
    desk_id        INTEGER        NOT NULL,
    ch_employee_id INTEGER        NOT NULL,
    ch_dt          TIMESTAMPTZ    NOT NULL
);