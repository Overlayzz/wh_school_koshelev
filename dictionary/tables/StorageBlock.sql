CREATE TABLE IF NOT EXISTS dictionary.storageblock
(
    storageblock_id SMALLSERIAL  NOT NULL
        CONSTRAINT pk_storageblock PRIMARY KEY,
    place           VARCHAR(100) NOT NULL
);