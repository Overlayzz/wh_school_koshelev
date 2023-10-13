CREATE TABLE IF NOT EXISTS humanresource.client
(
    client_id      INTEGER      NOT NULL
        CONSTRAINT pk_client PRIMARY KEY,
    name           VARCHAR(200) NOT NULL,
    card_number    VARCHAR(16)  NOT NULL,
    ch_employee_id INTEGER      NOT NULL,
    ch_dt          TIMESTAMPTZ  NOT NULL,
    CONSTRAINT uq_clientcard_cardnumber_client UNIQUE (card_number, client_id)
);