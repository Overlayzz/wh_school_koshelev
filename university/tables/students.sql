CREATE TABLE IF NOT EXISTS university.students
(
    id   INTEGER     NOT NULL,
    male CHAR(1)     NOT NULL,
    name VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Students PRIMARY KEY (id)
);