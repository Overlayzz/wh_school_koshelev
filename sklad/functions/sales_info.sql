CREATE OR REPLACE FUNCTION sklad.sales_info(_client_id INT) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    SET TIME ZONE 'Europe/Moscow';

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT s.date               AS "Дата",
                     p.name               AS "Наименование продукта",
                     s.quantity           AS "Количество",
                     p.price              AS "Цена за ед.",
                     p.price * s.quantity AS "Сумма"
              FROM Sklad.Sales s
                       INNER JOIN Sklad.Client c ON c.id = s.client_id
                       INNER JOIN Sklad.Product p ON p.id = s.product_id
              WHERE c.id = _client_id) res;
END
$$;