CREATE OR REPLACE FUNCTION dictionary.storageblock_getinfo(_storageblock_id INTEGER DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT s.storageblock_id,
                     s.place
              FROM dictionary.storageblock s
              WHERE s.storageblock_id = COALESCE(_storageblock_id, s.storageblock_id)) res;
END
$$;