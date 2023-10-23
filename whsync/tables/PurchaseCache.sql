CREATE TABLE IF NOT EXISTS whsync.purchasecache
(
    log_id         BIGSERIAL   NOT NULL
        CONSTRAINT pk_purchasecache PRIMARY KEY,
    purchase_id    INTEGER     NOT NULL,
    details        JSONB,
    supplier_id    INTEGER     NOT NULL,
    is_approved    BOOLEAN     NOT NULL,
    order_date     DATE        NOT NULL,
    delivery_date  DATE,
    sync_dt        TIMESTAMPTZ,
    ch_employee_id INTEGER     NOT NULL,
    ch_dt          TIMESTAMPTZ NOT NULL
);