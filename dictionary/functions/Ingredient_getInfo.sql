CREATE OR REPLACE FUNCTION dictionary.ingredient_getinfo(_data JSONB DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _ingredient_id     INTEGER DEFAULT NULL;
    _ingredienttype_id INTEGER DEFAULT NULL;
BEGIN
    SELECT s.ingredient_id,
           s.ingredienttype_id
    INTO _ingredient_id,
        _ingredienttype_id
    FROM JSONB_TO_RECORD(_data) AS s (ingredient_id     INTEGER,
                                      ingredienttype_id INTEGER);

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT ing.ingredient_id,
                     ing.name,
                     ing.ingredienttype_id
              FROM dictionary.ingredient ing
              WHERE ing.ingredient_id     = COALESCE(_ingredient_id, ing.ingredient_id)
                AND ing.ingredienttype_id = COALESCE(_ingredienttype_id, ing.ingredienttype_id)
              ) res;
END
$$;