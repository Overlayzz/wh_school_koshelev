CREATE TABLE IF NOT EXISTS humanresource.client
(
    id       INTEGER      NOT NULL
        CONSTRAINT pk_client PRIMARY KEY,
    name     VARCHAR(200) NOT NULL,
    phone    VARCHAR(11)  NOT NULL,
    birth    DATE         NOT NULL,
    order_id INTEGER      NOT NULL
);