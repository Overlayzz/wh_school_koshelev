--3.3 Выведет данные о товарах, которые имеют цену в диапазоне от 100 до 300 (включая границы диапазона).
CREATE OR REPLACE FUNCTION sklad.productrange_info() RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    SET TIME ZONE 'Europe/Moscow';

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT *
              FROM sklad.product p
              WHERE p.price >= 100
                AND p.price <= 300) res;
END
$$;
SELECT sklad.product_range_info();