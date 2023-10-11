CREATE TABLE IF NOT EXISTS dictionary.ingredienttype
(
    id              SMALLSERIAL  NOT NULL
        CONSTRAINT pk_ingredienttype PRIMARY KEY,
    storageblock_id INTEGER  NOT NULL,
    name            VARCHAR(100) NOT NULL
);