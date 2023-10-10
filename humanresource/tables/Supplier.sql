CREATE TABLE IF NOT EXISTS humanresource.supplier
(
    id    INTEGER      NOT NULL
        CONSTRAINT pk_supplier PRIMARY KEY,
    name  VARCHAR(100) NOT NULL,
    phone VARCHAR(11)  NOT NULL,
    email VARCHAR(50)  NOT NULL
);
