CREATE OR REPLACE FUNCTION sklad.curday_info(_dt DATE) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    SET TIME ZONE 'Europe/Moscow';

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT product.name      AS "Наименование продукта",
                     sales.quantity    AS "Количество",
                     client.first_name AS "Имя клиента"
              FROM sklad.sales
                       INNER JOIN sklad.product ON sales.product_id = product.id
                       INNER JOIN sklad.client ON sales.client_id = client.id
              WHERE DATE_TRUNC('day', sales.date) = _dt) res;
END
$$;