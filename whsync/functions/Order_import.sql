CREATE OR REPLACE FUNCTION whsync.order_import(_data jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    WITH data_cte AS (SELECT s.order_id,
                             s.total_price,
                             s.payment_type,
                             s.menu,
                             s.card_number,
                             s.desk_id,
                             s.ch_dt,
                             s.ch_employee_id,
                             ROW_NUMBER() OVER (PARTITION BY s.order_id ORDER BY s.ch_dt DESC) rn
                      FROM JSONB_TO_RECORDSET(_data) AS s (order_id       BIGINT,
                                                           total_price    NUMERIC(15, 2),
                                                           payment_type   VARCHAR(20),
                                                           menu           JSONB,
                                                           card_number    VARCHAR(16),
                                                           desk_id        INTEGER,
                                                           ch_dt          TIMESTAMPTZ,
                                                           ch_employee_id INTEGER))


    , upd_cte AS (INSERT INTO restaurant.order AS ins (order_id,
                                                       total_price,
                                                       payment_type,
                                                       menu,
                                                       card_number,
                                                       desk_id,
                                                       ch_dt,
                                                       ch_employee_id)
        SELECT c.order_id,
               c.total_price,
               c.payment_type,
               c.menu,
               c.card_number,
               c.desk_id,
               c.ch_dt,
               c.ch_employee_id
        FROM data_cte c
        WHERE c.rn = 1
        ON CONFLICT (order_id) DO UPDATE
            SET total_price    = excluded.total_price,
                payment_type   = excluded.payment_type,
                menu           = excluded.menu,
                card_number    = excluded.card_number,
                desk_id        = excluded.desk_id,
                ch_dt          = excluded.ch_dt,
                ch_employee_id = excluded.ch_employee_id
            WHERE ins.ch_dt <= excluded.ch_dt
        RETURNING ins.*)
    INSERT INTO history.orderchanges AS hist (order_id,
                                              total_price,
                                              payment_type,
                                              menu,
                                              card_number,
                                              desk_id,
                                              ch_dt,
                                              ch_employee_id)
        SELECT u.order_id,
               u.total_price,
               u.payment_type,
               u.menu,
               u.card_number,
               u.desk_id,
               u.ch_dt,
               u.ch_employee_id
        FROM upd_cte u;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;