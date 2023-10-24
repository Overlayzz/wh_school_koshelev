CREATE OR REPLACE FUNCTION restaurant.purchase_upd(_data           jsonb,
                                                   _ch_employee_id INT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _purchase_id   INTEGER;
    _details       JSONB;
    _supplier_id   INTEGER;
    _is_approved   BOOLEAN DEFAULT FALSE;
    _order_date    DATE;
    _delivery_date DATE;
    _ch_dt         TIMESTAMPTZ := NOW();
BEGIN
    SELECT COALESCE(pur.purchase_id, NEXTVAL('restaurant.restaurantsq')) AS fid,
           s.details,
           s.supplier_id,
           s.order_date,
           s.delivery_date
    INTO _purchase_id,
        _details,
        _supplier_id,
        _order_date,
        _delivery_date
    FROM JSONB_TO_RECORD(_data) AS s (purchase_id   INTEGER,
                                      details       JSONB,
                                      supplier_id   INTEGER,
                                      order_date    DATE,
                                      delivery_date DATE)
             LEFT JOIN restaurant.purchase pur ON pur.purchase_id = s.purchase_id;

    IF _delivery_date IS NOT NULL
    THEN
        _is_approved = TRUE;
    END IF;

    WITH ins_cte AS (
        INSERT INTO restaurant.purchase AS pur (purchase_id,
                                                details,
                                                supplier_id,
                                                is_approved,
                                                order_date,
                                                delivery_date,
                                                ch_dt,
                                                ch_employee_id)
            SELECT _purchase_id,
                   _details,
                   _supplier_id,
                   _is_approved,
                   _order_date,
                   _delivery_date,
                   _ch_dt,
                   _ch_employee_id
            ON CONFLICT (purchase_id) DO UPDATE
                SET details        = excluded.details,
                    supplier_id    = excluded.supplier_id,
                    is_approved    = excluded.is_approved,
                    order_date     = excluded.order_date,
                    delivery_date  = excluded.delivery_date,
                    ch_dt          = excluded.ch_dt,
                    ch_employee_id = excluded.ch_employee_id
                WHERE pur.ch_dt <= excluded.ch_dt
            RETURNING pur.*)

    ,hist_cte AS (INSERT INTO history.purchasechanges (purchase_id,
                                                      details,
                                                      supplier_id,
                                                      is_approved,
                                                      order_date,
                                                      delivery_date,
                                                      ch_dt,
                                                      ch_employee_id)
    SELECT ins.purchase_id,
           ins.details,
           ins.supplier_id,
           ins.is_approved,
           ins.order_date,
           ins.delivery_date,
           ins.ch_dt,
           ins.ch_employee_id
    FROM ins_cte ins)

    INSERT INTO whsync.purchasecache (purchase_id,
                                      details,
                                      supplier_id,
                                      is_approved,
                                      order_date,
                                      delivery_date,
                                      ch_dt,
                                      ch_employee_id)
    SELECT ins.purchase_id,
           ins.details,
           ins.supplier_id,
           ins.is_approved,
           ins.order_date,
           ins.delivery_date,
           ins.ch_dt,
           ins.ch_employee_id
    FROM ins_cte ins;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;