CREATE OR REPLACE FUNCTION dictionary.foodtype_upd(_data json) RETURNS json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _foodtype_id INTEGER;
    _name        VARCHAR(100);
BEGIN
    SELECT COALESCE(ft.foodtype_id, NEXTVAL('dictionary.foodtype_foodtype_id_seq')) AS foodtype_id,
           s.name
    INTO _foodtype_id,
         _name
    FROM JSON_TO_RECORD(_data) AS s (foodtype_id INTEGER,
                                     name        VARCHAR(100))
                    LEFT JOIN dictionary.foodtype ft ON ft.foodtype_id = s.foodtype_id;

    IF EXISTS(SELECT 1
              FROM dictionary.foodtype ft
              WHERE ft.foodtype_id = _foodtype_id
                AND ft.name = _name)
    THEN
        RETURN public.errmessage('dictionary.foodtype_upd.duplicate',
                                 'Такая запись уже существует!',
                                 '');
    END IF;

    INSERT INTO dictionary.foodtype AS ins (foodtype_id,
                                            name)
    SELECT _foodtype_id,
           _name
    ON CONFLICT (foodtype_id) DO UPDATE
        SET name = excluded.name;

    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;