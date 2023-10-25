CREATE OR REPLACE FUNCTION history.partitionedtables_delete(_table_name TEXT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _target_date    DATE := NOW() - INTERVAL '3 months';
    _partition_name TEXT;
BEGIN
    FOR _partition_name IN
        SELECT relname
        FROM pg_class
        WHERE SUBSTRING(relname FROM CONCAT(_table_name, '_([0-9]+)'))::TEXT <
              TO_CHAR((_target_date)::DATE, 'YYYYMM')::TEXT
        LOOP
            EXECUTE FORMAT('DROP TABLE history.%I', _partition_name);
        END LOOP;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;