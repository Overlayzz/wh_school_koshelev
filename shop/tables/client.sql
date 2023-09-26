CREATE TABLE IF NOT EXISTS shop.client
(
    client_id   INTEGER     NOT NULL,
    name        VARCHAR(30) NOT NULL,
    phone       VARCHAR(11),
    dt          TIMESTAMPTZ NOT NULL,
    ch_employee INTEGER     NOT NULL,
    CONSTRAINT pk_client PRIMARY KEY (client_id),
    CONSTRAINT uq_client_phone UNIQUE (phone)
);