CREATE TABLE IF NOT EXISTS restaurant.order
(
    id           BIGINT         NOT NULL
        CONSTRAINT pk_order PRIMARY KEY,
    total_price  NUMERIC(15, 2) NOT NULL,
    payment_type VARCHAR(20)    NOT NULL,
    menu         JSONB          NOT NULL,
    client_id    INTEGER,
    desk_id      INTEGER        NOT NULL,
    employee_id  INTEGER        NOT NULL,
    ch_dt        TIMESTAMPTZ    NOT NULL
);