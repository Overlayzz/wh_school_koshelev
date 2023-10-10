CREATE TABLE IF NOT EXISTS dictionary.employeetype
(
    id       SMALLSERIAL  NOT NULL
        CONSTRAINT pk_employeetype PRIMARY KEY,
    position VARCHAR(100) NOT NULL,
    details  VARCHAR(200)
);