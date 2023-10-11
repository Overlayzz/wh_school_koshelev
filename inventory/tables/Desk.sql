CREATE TABLE IF NOT EXISTS inventory.desk
(
    id             SMALLINT NOT NULL
        CONSTRAINT pk_desk PRIMARY KEY,
    table_number   SMALLINT NOT NULL,
    seat_count     SMALLINT NOT NULL,
    is_reservation BOOLEAN  NOT NULL,
    location       VARCHAR(100)
);