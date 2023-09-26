CREATE TABLE IF NOT EXISTS sklad.client
(
    ID         INT         DEFAULT nextval('sklad.sklad_sq'),
    First_Name VARCHAR(30) NOT NULL,
    Phone      VARCHAR(11) NOT NULL,
    CONSTRAINT PK_Client PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS sklad.product
(
    ID    INT            DEFAULT nextval('sklad.sklad_sq'),
    Name  VARCHAR(30)    NOT NULL,
    Price NUMERIC(10, 2) NOT NULL CHECK (Price > 0),
    CONSTRAINT PK_Product PRIMARY KEY (ID),
    CONSTRAINT ch_price CHECK (Price > 0)
);

CREATE TABLE IF NOT EXISTS sklad.sales
(
    ID         INT         DEFAULT nextval('sklad.sklad_sq'),
    Date       TIMESTAMPTZ NOT NULL,
    Client_id  INT         NOT NULL,
    Product_id INT         NOT NULL,
    Quantity   INT         NOT NULL,
    CONSTRAINT PK_prod PRIMARY KEY (ID),
    CONSTRAINT ch_kol CHECK (Quantity > 0)
);