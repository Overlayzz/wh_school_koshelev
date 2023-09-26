INSERT INTO sklad.client (First_Name, Phone)
SELECT (ARRAY ['Алексей', 'Мария', 'Дмитрий', 'Анна', 'Иван',
    'Екатерина', 'Александр', 'София', 'Михаил', 'Анастасия',
    'Сергей', 'Алиса', 'Егор', 'Виктория', 'Никита', 'Ксения',
    'Артем', 'Елена', 'Даниил', 'Валерия', 'Андрей',
    'Кристина', 'Илья', 'Надежда', 'Максим', 'Ольга',
    'Глеб', 'Юлия', 'Павел', 'Татьяна'])[FLOOR(RANDOM() * 30 + 1)]         AS First_Name,
       CONCAT('8', FLOOR(RANDOM() * 9000000000 + 1000000000))::VARCHAR(11) AS Phone
FROM GENERATE_SERIES(1, 10);

INSERT INTO sklad.product (Name, Price)
SELECT (ARRAY ['Карандаш', 'Ручка', 'Степлер', 'Бумага', 'Ножницы',
    'Батарейка', 'Фломастер', 'Ластик', 'Клей', 'Скотч'])[ROW_NUMBER() OVER ()] AS NAME,
       (RANDOM() * 1000)::NUMERIC(10, 2)                                        AS Price
FROM GENERATE_SERIES(1, 10);

SET TIME ZONE 'Europe/Moscow';
WITH c AS (SELECT MIN(id) AS min_id,
                  MAX(id) AS max_id
           FROM sklad.client),
     p AS (SELECT MIN(id) AS min_id,
                  MAX(id) AS max_id
           FROM sklad.product)
INSERT
INTO sklad.sales (Date, Client_id, Product_id, Quantity)
SELECT NOW() - RANDOM() * INTERVAL '1 year'                   AS date,
       FLOOR(c.min_id + RANDOM() * (c.max_id - c.min_id + 1)) AS client_id,
       FLOOR(p.min_id + RANDOM() * (p.max_id - p.min_id + 1)) AS product_id,
       FLOOR(RANDOM() * 20) + 1                               AS quantity
FROM c,
     p, GENERATE_SERIES(1, 30);


