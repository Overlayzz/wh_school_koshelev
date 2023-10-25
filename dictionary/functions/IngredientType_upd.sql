CREATE OR REPLACE FUNCTION dictionary.ingredienttype_upd(_data json) RETURNS json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _ingredienttype_id INTEGER;
    _name              VARCHAR(100);
    _storageblock_id   INTEGER;
BEGIN
    SELECT COALESCE(it.ingredienttype_id, NEXTVAL('dictionary.ingredienttype_ingredienttype_id_seq')) AS ingredienttype_id,
           s.name,
           s.storageblock_id
    INTO _ingredienttype_id,
         _name,
         _storageblock_id
    FROM JSON_TO_RECORD(_data) AS s (ingredienttype_id INTEGER,
                                     name              VARCHAR(100),
                                     storageblock_id   INTEGER)
             LEFT JOIN dictionary.ingredienttype it ON it.ingredienttype_id = s.ingredienttype_id;

    IF EXISTS(SELECT 1
              FROM dictionary.ingredienttype it
              WHERE it.ingredienttype_id = _ingredienttype_id
                AND it.name = _name)
    THEN
        RETURN public.errmessage('dictionary.ingredienttype_upd.duplicate',
                                 'Такая запись уже существует!',
                                 '');
    END IF;

    INSERT INTO dictionary.ingredienttype AS ins (ingredienttype_id,
                                                  name,
                                                  storageblock_id)
    SELECT _ingredienttype_id,
           _name,
           _storageblock_id
    ON CONFLICT (ingredienttype_id) DO UPDATE
        SET name            = excluded.name,
            storageblock_id = excluded.storageblock_id;

    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;