CREATE TABLE IF NOT EXISTS sklad.client
(
    id         INTEGER     NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    phone      VARCHAR(11) NOT NULL,
    CONSTRAINT PK_Client PRIMARY KEY (id)
);