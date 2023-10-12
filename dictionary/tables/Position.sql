CREATE TABLE IF NOT EXISTS dictionary.position
(
    position_id SMALLSERIAL    NOT NULL
        CONSTRAINT pk_position PRIMARY KEY,
    name        VARCHAR(100)   NOT NULL,
    salary      NUMERIC(15, 2) NOT NULL
);