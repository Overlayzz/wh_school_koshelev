CREATE TABLE IF NOT EXISTS history.purchasechanges
(
    log_id         BIGSERIAL   NOT NULL
        CONSTRAINT pk_purchasechanges PRIMARY KEY,
    purchase_id    INTEGER     NOT NULL,
    details        JSONB,
    supplier_id    INTEGER     NOT NULL,
    is_approved    BOOLEAN     NOT NULL,
    order_date     DATE        NOT NULL,
    delivery_date  DATE,
    ch_employee_id INTEGER     NOT NULL,
    ch_dt          TIMESTAMPTZ NOT NULL
);