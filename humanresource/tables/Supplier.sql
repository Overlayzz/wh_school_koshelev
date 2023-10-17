CREATE TABLE IF NOT EXISTS humanresource.supplier
(
    supplier_id INTEGER      NOT NULL
        CONSTRAINT pk_supplier PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    phone       VARCHAR(11)  NOT NULL,
    email       VARCHAR(50)  NOT NULL,
    inn         VARCHAR(12)  NOT NULL,
    CONSTRAINT uq_supplier_supplier_inn UNIQUE (supplier_id, inn)
);