CREATE OR REPLACE FUNCTION inventory.desk_upd(_data jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _desk_id        INTEGER;
    _table_number   INTEGER;
    _seat_count     INTEGER;
    _is_reservation BOOLEAN;
    _location       VARCHAR(100);
BEGIN
    SELECT COALESCE(d.desk_id, NEXTVAL('inventory.inventorysq')) AS ds_id,
           s.table_number,
           s.seat_count,
           COALESCE(s.is_reservation, FALSE),
           s.location
    INTO _desk_id,
         _table_number,
         _seat_count,
         _is_reservation,
         _location
    FROM JSONB_TO_RECORD(_data) AS s (desk_id        SMALLINT,
                                      table_number   SMALLINT,
                                      seat_count     SMALLINT,
                                      is_reservation BOOLEAN,
                                      location       VARCHAR(100))
             LEFT JOIN inventory.desk d ON d.desk_id = s.desk_id;

    INSERT INTO inventory.desk AS ins (desk_id,
                                       table_number,
                                       seat_count,
                                       is_reservation,
                                       location)
    SELECT _desk_id,
           _table_number,
           _seat_count,
           _is_reservation,
           _location
    ON CONFLICT(desk_id, table_number) DO UPDATE
        SET seat_count     = excluded.seat_count,
            is_reservation = excluded.is_reservation,
            location       = excluded.location;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;