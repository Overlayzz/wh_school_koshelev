CREATE TABLE IF NOT EXISTS history.clientchanges
(
    log_id      BIGSERIAL   NOT NULL,
    client_id   INTEGER     NOT NULL,
    name        VARCHAR(30) NOT NULL,
    phone       VARCHAR(11),
    dt          TIMESTAMPTZ NOT NULL,
    ch_employee INT         NOT NULL
);