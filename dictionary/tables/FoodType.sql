CREATE TABLE IF NOT EXISTS dictionary.foodtype
(
    foodtype_id SMALLSERIAL  NOT NULL
        CONSTRAINT pk_foodtype PRIMARY KEY,
    name        VARCHAR(100) NOT NULL
);