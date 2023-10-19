CREATE OR REPLACE FUNCTION whsync.order_export(_log_id BIGINT) RETURNS jsonb
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
    FROM whsync.ordercache oc
    WHERE oc.log_id <= _log_id
      AND oc.sync_dt IS NOT NULL;

    WITH sync_cte AS (SELECT oc.log_id,
                             oc.order_id,
                             oc.total_price,
                             oc.payment_type,
                             oc.menu,
                             oc.card_number,
                             oc.desk_id,
                             oc.ch_employee_id,
                             oc.ch_dt
                      FROM whsync.ordercache oc
                      ORDER BY oc.log_id
                      LIMIT 1000)

        ,upd_cte AS (
             UPDATE whsync.ordercache oc
             SET sync_dt = _dt
             FROM sync_cte sc
             WHERE oc.log_id = sc.log_id)
    SELECT JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(sc)))
    INTO _res
    FROM sync_cte sc;

    RETURN _res;
END
$$;