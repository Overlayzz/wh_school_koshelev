CREATE OR REPLACE FUNCTION inventory.desk_getinfo(_data JSONB DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _desk_id        INTEGER DEFAULT NULL;
    _is_reservation BOOLEAN DEFAULT NULL;
BEGIN
    SELECT s.desk_id,
           s.is_reservation
    INTO _desk_id,
         _is_reservation
    FROM JSONB_TO_RECORD(_data) AS s (desk_id        INTEGER,
                                      is_reservation BOOLEAN);

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT d.desk_id,
                     d.table_number,
                     d.seat_count,
                     d.is_reservation,
                     d.location
              FROM inventory.desk d
              WHERE d.desk_id        = COALESCE(_desk_id, d.desk_id)
                AND d.is_reservation = COALESCE(_is_reservation, d.is_reservation)
              ) res;
END
$$;