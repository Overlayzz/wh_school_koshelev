CREATE TABLE IF NOT EXISTS humanresource.employee
(
    id              INTEGER        NOT NULL
        CONSTRAINT pk_employee PRIMARY KEY,
    name            VARCHAR(200)   NOT NULL,
    birth           DATE           NOT NULL,
    salary          NUMERIC(15, 2) NOT NULL,
    employeetype_id INTEGER        NOT NULL
);