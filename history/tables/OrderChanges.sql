CREATE TABLE IF NOT EXISTS history.orderchanges
(
    log_id         BIGSERIAL      NOT NULL
        CONSTRAINT pk_orderchanges PRIMARY KEY,
    order_id       BIGINT         NOT NULL,
    total_price    NUMERIC(15, 2) NOT NULL,
    payment_type   VARCHAR(20)    NOT NULL,
    menu           JSONB          NOT NULL,
    card_number    VARCHAR(16)    NOT NULL,
    desk_id        INTEGER        NOT NULL,
    ch_employee_id INTEGER        NOT NULL,
    ch_dt          TIMESTAMPTZ    NOT NULL
);