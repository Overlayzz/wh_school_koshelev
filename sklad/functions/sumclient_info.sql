--3.5 Выведет информацию о клиентах, которые суммарно купили больше товара, чем среднее по всем клиентам.
CREATE OR REPLACE FUNCTION sklad.sumclient_info() RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    SET TIME ZONE 'Europe/Moscow';

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT c.id,
                     c.first_name   AS "Имя клиента",
                     SUM(s.quantity) AS "Суммарное количество"
              FROM sklad.client c
                       INNER JOIN sklad.sales s ON c.id = s.client_id
              GROUP BY c.id, c.first_name
              HAVING SUM(s.quantity) > (SELECT ROUND(AVG(sq.sumQ))
                                        FROM (SELECT SUM(s.quantity) AS sumQ
                                              FROM sklad.sales s
                                              GROUP BY s.client_id) sq)) res;
END
$$;
SELECT sklad.sum_client_info();