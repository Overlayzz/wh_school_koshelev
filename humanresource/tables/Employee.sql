CREATE TABLE IF NOT EXISTS humanresource.employee
(
    id          INTEGER      NOT NULL
        CONSTRAINT pk_employee PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    birth       DATE         NOT NULL,
    position_id INTEGER      NOT NULL,
    is_delete   BOOLEAN      NOT NULL,
    employee_id INTEGER      NOT NULL,
    ch_dt       TIMESTAMPTZ  NOT NULL
);