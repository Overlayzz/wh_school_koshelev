CREATE OR REPLACE FUNCTION inventory.desk_getinfo(_desk_id        INTEGER,
                                                  _is_reservation BOOLEAN) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
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