CREATE TABLE IF NOT EXISTS history.ingredientchanges
(
    log_id            BIGSERIAL    NOT NULL
        CONSTRAINT pk_ingredientchanges PRIMARY KEY,
    ingredient_id     SMALLSERIAL  NOT NULL,
    name              VARCHAR(100) NOT NULL,
    ingredienttype_id INTEGER      NOT NULL,
    ch_employee_id    INTEGER      NOT NULL,
    ch_dt             TIMESTAMPTZ  NOT NULL
);