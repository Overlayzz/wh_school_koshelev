CREATE TABLE IF NOT EXISTS history.foodchanges
(
    log_id         BIGSERIAL      NOT NULL
        CONSTRAINT pk_foodchanges PRIMARY KEY,
    food_id        INTEGER        NOT NULL,
    name           VARCHAR(100)   NOT NULL,
    weight         INTEGER        NOT NULL,
    price          NUMERIC(15, 2) NOT NULL,
    ingredients    JSONB          NOT NULL,
    is_delete      BOOLEAN        NOT NULL,
    foodtype_id    INTEGER        NOT NULL,
    ch_employee_id INTEGER        NOT NULL,
    ch_dt          TIMESTAMPTZ    NOT NULL
);