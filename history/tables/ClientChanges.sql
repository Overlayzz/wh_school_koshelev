CREATE TABLE IF NOT EXISTS history.clientchanges
(
    log_id         BIGSERIAL    NOT NULL
        CONSTRAINT pk_clientchanges PRIMARY KEY,
    client_id      INTEGER      NOT NULL,
    card_number    VARCHAR(16)  NOT NULL,
    name           VARCHAR(200) NOT NULL,
    ch_employee_id INTEGER      NOT NULL,
    ch_dt          TIMESTAMPTZ  NOT NULL
);