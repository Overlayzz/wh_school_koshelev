CREATE TABLE IF NOT EXISTS humanresource.clientcard
(
    id          INTEGER     NOT NULL
        CONSTRAINT pk_clientcard PRIMARY KEY,
    client_id   INTEGER     NOT NULL,
    card_number VARCHAR(16) NOT NULL,
    employee_id INTEGER     NOT NULL,
    ch_dt       TIMESTAMPTZ NOT NULL
);