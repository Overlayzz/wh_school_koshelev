CREATE TABLE IF NOT EXISTS history.clientcardchanges
(
    log_id         BIGSERIAL   NOT NULL
        CONSTRAINT pk_clientcardchanges PRIMARY KEY,
    clientcard_id  INTEGER     NOT NULL,
    client_id      INTEGER     NOT NULL,
    card_number    VARCHAR(16) NOT NULL,
    ch_employee_id INTEGER     NOT NULL,
    ch_dt          TIMESTAMPTZ NOT NULL
);