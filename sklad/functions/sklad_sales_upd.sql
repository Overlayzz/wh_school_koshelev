CREATE OR REPLACE FUNCTION sklad.sales_upd(_data JSON) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _errcode     VARCHAR(200);
    _err_message VARCHAR(500);
BEGIN
    CREATE TEMP TABLE tmp ON COMMIT DROP AS
    SELECT COALESCE(s.id, nextval('sklad.sales_sq')) AS id,
           COALESCE(s.date, NOW()) AS dt,
           s.client_id,
           s.product_id,
           s.quantity
    FROM JSON_TO_RECORDSET(_data) AS s (id INT,
                                        date TIMESTAMP,
                                        client_id INT,
                                        product_id INT,
                                        quantity INT);

    SELECT CASE
               WHEN c.id IS NULL       THEN 'sales_upd.empty_params_client'
               WHEN p.id IS NULL       THEN 'sales_upd.empty_params_product'
               WHEN t.quantity IS NULL THEN 'sales_upd.empty_params_quantity'
               WHEN t.quantity <= 0    THEN 'sales_upd.err_params_quantity'
               WHEN EXISTS (SELECT 1 FROM sklad.sales s
                                     WHERE s.id = t.id
                                       AND s.date = t.dt)
                                       THEN 'sales_upd.duplicate'
               ELSE NULL
               END
    INTO _errcode
    FROM tmp t
             LEFT JOIN sklad.client c  ON t.client_id = c.id
             LEFT JOIN sklad.product p ON t.product_id = p.id;
    SELECT CASE _errcode
               WHEN 'sales_upd.empty_params_client'   THEN 'Введенного клиента не существует'
               WHEN 'sales_upd.empty_params_product'  THEN 'Введенного товара не существует'
               WHEN 'sales_upd.empty_params_quantity' THEN 'Количество пустое'
               WHEN 'sales_upd.err_params_quantity'   THEN 'Количество не может быть равным 0 или отрицательным'
               WHEN 'sales_upd.duplicate'             THEN 'Такая запись уже есть'
               ELSE NULL
               END
    INTO _err_message;
    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage(_errcode, _err_message, NULL);
    END IF;

    INSERT INTO sklad.sales AS ins (id, date, client_id, product_id, quantity)
    SELECT t.id,
           t.dt,
           t.client_id,
           t.product_id,
           t.quantity
    FROM tmp t
    ON CONFLICT (id) DO UPDATE
        SET date       = excluded.date,
            client_id  = excluded.client_id,
            product_id = excluded.product_id,
            quantity   = excluded.quantity;
    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;