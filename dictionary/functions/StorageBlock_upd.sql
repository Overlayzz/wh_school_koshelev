CREATE OR REPLACE FUNCTION dictionary.storageblock_upd(_data json) RETURNS json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _storageblock_id INTEGER;
    _place           VARCHAR(100);
BEGIN
    SELECT COALESCE(sb.storageblock_id, NEXTVAL('dictionary.storageblock_storageblock_id_seq')) AS storageblock_id,
           s.place
    INTO _storageblock_id,
         _place
    FROM JSON_TO_RECORD(_data) AS s (storageblock_id INTEGER,
                                     place           VARCHAR(100))
             LEFT JOIN dictionary.storageblock sb ON sb.storageblock_id = s.storageblock_id;

    IF EXISTS(SELECT 1
              FROM dictionary.storageblock sb
              WHERE sb.storageblock_id = _storageblock_id
                AND sb.place = _place)
    THEN
        RETURN public.errmessage('dictionary.storageblock_upd.duplicate',
                                 'Такая запись уже существует!',
                                 '');
    END IF;

    INSERT INTO dictionary.storageblock AS ins (storageblock_id,
                                                place)
    SELECT _storageblock_id,
           _place
    ON CONFLICT (storageblock_id) DO UPDATE
        SET place = excluded.place;

    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;