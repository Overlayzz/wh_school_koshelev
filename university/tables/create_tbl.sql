CREATE TABLE IF NOT EXISTS university.students
(
    ID   INT         NOT NULL,
    Male CHAR(1)     NOT NULL,
    Name VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Students PRIMARY KEY (ID)
);