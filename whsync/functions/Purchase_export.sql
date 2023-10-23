CREATE OR REPLACE FUNCTION whsync.purchase_export(_log_id BIGINT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt  TIMESTAMPTZ;
    _res JSONB;
BEGIN
    SET TIME ZONE 'Europe/Moscow';
    _dt := NOW();

    DELETE
    FROM whsync.purchasecache pc
    WHERE pc.log_id <= _log_id
      AND pc.sync_dt IS NOT NULL;

    WITH sync_cte AS (SELECT pc.log_id,
                             pc.purchase_id,
                             pc.details,
                             pc.supplier_id,
                             pc.is_approved,
                             pc.order_date,
                             pc.delivery_date,
                             pc.sync_dt,
                             pc.ch_employee_id,
                             pc.ch_dt
                      FROM whsync.purchasecache pc
                      ORDER BY pc.log_id
                      LIMIT 1000)

        ,upd_cte AS (
             UPDATE whsync.purchasecache pc
             SET sync_dt = _dt
             FROM sync_cte sc
             WHERE pc.log_id = sc.log_id)
    SELECT JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(sc)))
    INTO _res
    FROM sync_cte sc;

    RETURN _res;
END
$$;