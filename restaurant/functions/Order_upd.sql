CREATE OR REPLACE FUNCTION restaurant.order_upd(_data jsonb,
                                                _ch_employee_id INT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _order_id     BIGINT;
    _total_price  NUMERIC(15, 2);
    _payment_type VARCHAR(20);
    _menu         JSONB;
    _card_number  VARCHAR(16);
    _desk_id      INTEGER;
    _ch_dt        TIMESTAMPTZ := NOW();
BEGIN
    SELECT COALESCE(ord.order_id, NEXTVAL('restaurant.restaurantsq')) AS fid,
           s.payment_type,
           s.menu,
           s.card_number,
           s.desk_id
    INTO _order_id,
         _payment_type,
         _menu,
         _card_number,
         _desk_id
    FROM JSONB_TO_RECORD(_data) AS s (order_id     BIGINT,
                                      payment_type VARCHAR(20),
                                      menu         JSONB,
                                      card_number  VARCHAR(16),
                                      desk_id      INTEGER)
             LEFT JOIN restaurant.order ord ON ord.order_id = s.order_id;

    SELECT SUM(f.price * (m->>'amount')::INTEGER)
    INTO _total_price
    FROM jsonb_array_elements(_menu) AS m
    JOIN inventory.food AS f ON f.food_id = (m->>'food_id')::INTEGER;

    WITH ins_cte AS (
        INSERT INTO restaurant.order AS ord (order_id,
                                             total_price,
                                             payment_type,
                                             menu,
                                             card_number,
                                             desk_id,
                                             ch_dt,
                                             ch_employee_id)
            SELECT _order_id,
                   _total_price,
                   _payment_type,
                   _menu,
                   _card_number,
                   _desk_id,
                   _ch_dt,
                   _ch_employee_id
            ON CONFLICT (order_id) DO UPDATE
                SET total_price    = excluded.total_price,
                    payment_type   = excluded.payment_type,
                    menu           = excluded.menu,
                    card_number    = excluded.card_number,
                    desk_id        = excluded.desk_id,
                    ch_dt          = excluded.ch_dt,
                    ch_employee_id = excluded.ch_employee_id
                WHERE ord.ch_dt <= excluded.ch_dt
            RETURNING ord.*)

    , his_cte AS (INSERT INTO history.orderchanges AS hist (order_id,
                                                            total_price,
                                                            payment_type,
                                                            menu,
                                                            card_number,
                                                            desk_id,
                                                            ch_dt,
                                                            ch_employee_id)
        SELECT ins.order_id,
               ins.total_price,
               ins.payment_type,
               ins.menu,
               ins.card_number,
               ins.desk_id,
               ins.ch_dt,
               ins.ch_employee_id
        FROM ins_cte ins)

    INSERT INTO whsync.ordercache (order_id,
                                   total_price,
                                   payment_type,
                                   menu,
                                   card_number,
                                   desk_id,
                                   ch_dt,
                                   ch_employee_id)
    SELECT ins.order_id,
           ins.total_price,
           ins.payment_type,
           ins.menu,
           ins.card_number,
           ins.desk_id,
           ins.ch_dt,
           ins.ch_employee_id
    FROM ins_cte ins;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;