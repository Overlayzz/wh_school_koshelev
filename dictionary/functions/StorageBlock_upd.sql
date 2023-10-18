CREATE OR REPLACE FUNCTION dictionary.storageblock_upd(_data json) RETURNS json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _place       VARCHAR(100);
BEGIN
    SELECT s.place
    INTO _place
    FROM JSON_TO_RECORDSET(_data) AS s (place VARCHAR(100));

    INSERT INTO dictionary.storageblock AS ins (place)
    SELECT _place;
    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;