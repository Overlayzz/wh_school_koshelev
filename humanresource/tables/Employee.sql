CREATE TABLE IF NOT EXISTS humanresource.employee
(
    employee_id    INTEGER      NOT NULL
        CONSTRAINT pk_employee PRIMARY KEY,
    name           VARCHAR(200) NOT NULL,
    phone          VARCHAR(11)  NOT NULL,
    birth          DATE         NOT NULL,
    position_id    INTEGER      NOT NULL,
    is_delete      BOOLEAN      NOT NULL,
    ch_employee_id INTEGER      NOT NULL,
    ch_dt          TIMESTAMPTZ  NOT NULL
);