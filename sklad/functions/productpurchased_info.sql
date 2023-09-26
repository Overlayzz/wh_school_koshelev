CREATE OR REPLACE FUNCTION sklad.productpurchased_info(_product_id INT) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    SET TIME ZONE 'Europe/Moscow';

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT c.id         AS "ID клиента",
                     c.first_name AS "Имя клиента",
                     c.phone         "Телефон"
              FROM sklad.client c
                       INNER JOIN sklad.sales s ON s.client_id = c.id
              WHERE s.product_id = _product_id) res;
END
$$;