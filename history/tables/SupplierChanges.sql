CREATE TABLE IF NOT EXISTS history.supplierchanges
(
    log_id         BIGSERIAL    NOT NULL
        CONSTRAINT pk_supplierchanges PRIMARY KEY,
    supplier_id    INTEGER      NOT NULL,
    name           VARCHAR(100) NOT NULL,
    phone          VARCHAR(11)  NOT NULL,
    email          VARCHAR(50)  NOT NULL,
    inn            VARCHAR(12)  NOT NULL,
    ch_employee_id INTEGER      NOT NULL,
    ch_dt          TIMESTAMPTZ  NOT NULL,
    CONSTRAINT uq_supplier_supplier_inn UNIQUE (supplier_id, inn)
);