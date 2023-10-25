CREATE OR REPLACE FUNCTION dictionary.ingredient_upd(_data json) RETURNS json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _ingredient_id     INTEGER;
    _name              VARCHAR(100);
    _ingredienttype_id INTEGER;
BEGIN
    SELECT COALESCE(i.ingredient_id, NEXTVAL('dictionary.ingredient_ingredient_id_seq')) AS ingredient_id,
           s.name,
           s.ingredienttype_id
    INTO _ingredient_id,
         _name,
         _ingredienttype_id
    FROM JSON_TO_RECORD(_data) AS s (ingredient_id     INTEGER,
                                     name              VARCHAR(100),
                                     ingredienttype_id INTEGER)
             LEFT JOIN dictionary.ingredient i ON i.ingredient_id = s.ingredient_id;

    IF EXISTS(SELECT 1
              FROM dictionary.ingredient i
              WHERE i.ingredient_id = _ingredient_id
                AND i.name = _name)
    THEN
        RETURN public.errmessage('dictionary.ingredient_upd.duplicate',
                                 'Такая запись уже существует!',
                                 '');
    END IF;

    INSERT INTO dictionary.ingredient AS ins (ingredient_id,
                                              name,
                                              ingredienttype_id)
    SELECT _ingredient_id,
           _name,
           _ingredienttype_id
    ON CONFLICT (ingredient_id) DO UPDATE
        SET name              = excluded.name,
            ingredienttype_id = excluded.ingredienttype_id;

    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;