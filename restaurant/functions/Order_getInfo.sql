CREATE OR REPLACE FUNCTION restaurant.order_getinfo(_data JSONB DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _order_id    INTEGER DEFAULT NULL;
    _card_number VARCHAR(16) DEFAULT NULL;
    _desk_id     INTEGER DEFAULT NULL;
BEGIN
    SELECT s.order_id,
           s.card_number,
           s.desk_id
    INTO _order_id,
         _card_number,
         _desk_id
    FROM JSONB_TO_RECORD(_data) AS s (order_id    INTEGER,
                                      card_number VARCHAR(16),
                                      desk_id     INTEGER);

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT ord.order_id,
                     ord.total_price,
                     ord.payment_type,
                     ord.menu,
                     ord.card_number,
                     ord.desk_id
              FROM restaurant.order ord
              WHERE ord.order_id    = COALESCE(_order_id, ord.order_id)
                AND ord.card_number = COALESCE(_card_number, ord.card_number)
                AND ord.desk_id     = COALESCE(_desk_id, ord.desk_id)
              ) res;
END
$$;