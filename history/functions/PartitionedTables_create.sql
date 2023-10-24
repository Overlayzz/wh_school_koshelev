CREATE OR REPLACE FUNCTION history.partitionedtables_create() RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _partition_date DATE := CURRENT_DATE;
    _end_date       DATE := CURRENT_DATE + INTERVAL '1 year';
BEGIN
    WHILE _partition_date < _end_date
        LOOP
            EXECUTE FORMAT(
                    'CREATE TABLE IF NOT EXISTS history.orderchanges_%s PARTITION OF history.orderchanges FOR VALUES FROM (%L) TO (%L);',
                    TO_CHAR(_partition_date, 'YYYYMM'), _partition_date, (_partition_date + INTERVAL '1 month'));
            _partition_date := _partition_date + INTERVAL '1 month';
        END LOOP;

    RETURN jsonb_build_object('data', NULL);
END
$$;
