CREATE OR REPLACE FUNCTION dictionary.ingredient_upd(_data json) RETURNS json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _name              VARCHAR(100);
    _ingredienttype_id INTEGER;
BEGIN
    SELECT s.name,
           s.ingredienttype_id
    INTO _name,
         _ingredienttype_id
    FROM JSON_TO_RECORDSET(_data) AS s (name              VARCHAR(100),
                                        ingredienttype_id INTEGER);

    INSERT INTO dictionary.ingredient AS ins (name,
                                              ingredienttype_id)
    SELECT _name,
           _ingredienttype_id;
    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;