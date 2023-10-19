CREATE OR REPLACE FUNCTION dictionary.storageblock_ins(_data json) RETURNS json
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

    IF EXISTS(SELECT 1
              FROM dictionary.storageblock sb
              WHERE sb.place = _place)
    THEN
        RETURN public.errmessage('dictionary.storageblock_upd.duplicate', 'Такая запись уже существует!', '');
    END IF;

    INSERT INTO dictionary.storageblock AS ins (place)
    SELECT _place;

    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;