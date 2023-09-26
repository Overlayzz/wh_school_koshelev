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