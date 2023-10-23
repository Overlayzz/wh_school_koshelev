CREATE OR REPLACE FUNCTION whsync.purchase_import(_data jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN
    WITH data_cte AS (SELECT s.purchase_id,
                             s.details,
                             s.supplier_id,
                             s.is_approved,
                             s.order_date,
                             s.delivery_date,
                             s.ch_employee_id,
                             s.ch_dt,
                             ROW_NUMBER() OVER (PARTITION BY s.purchase_id ORDER BY s.ch_dt DESC) rn
                      FROM JSONB_TO_RECORDSET(_data) AS s (purchase_id    INTEGER,
                                                           details        JSONB,
                                                           supplier_id    INTEGER,
                                                           is_approved    BOOLEAN,
                                                           order_date     DATE,
                                                           delivery_date  DATE,
                                                           ch_employee_id INTEGER,
                                                           ch_dt          TIMESTAMPTZ))


    , upd_cte AS (INSERT INTO restaurant.purchase AS ins (purchase_id,
                                                          details,
                                                          supplier_id,
                                                          is_approved,
                                                          order_date,
                                                          delivery_date,
                                                          ch_employee_id,
                                                          ch_dt)
        SELECT c.purchase_id,
               c.details,
               c.supplier_id,
               c.is_approved,
               c.order_date,
               c.delivery_date,
               c.ch_employee_id,
               c.ch_dt
        FROM data_cte c
        WHERE c.rn = 1
        ON CONFLICT (purchase_id) DO UPDATE
            SET details        = excluded.details,
                supplier_id    = excluded.supplier_id,
                is_approved    = excluded.is_approved,
                order_date     = excluded.order_date,
                delivery_date  = excluded.delivery_date,
                ch_employee_id = excluded.ch_employee_id,
                ch_dt          = excluded.ch_dt
            WHERE ins.ch_dt <= excluded.ch_dt
        RETURNING ins.*)

    INSERT INTO history.purchasechanges AS hist (purchase_id,
                                                 details,
                                                 supplier_id,
                                                 is_approved,
                                                 order_date,
                                                 delivery_date,
                                                 ch_employee_id,
                                                 ch_dt)
        SELECT u.purchase_id,
               u.details,
               u.supplier_id,
               u.is_approved,
               u.order_date,
               u.delivery_date,
               u.ch_employee_id,
               u.ch_dt
        FROM upd_cte u;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;