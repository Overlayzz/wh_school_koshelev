CREATE OR REPLACE FUNCTION dictionary.ingredient_getinfo(_ingredient_id INTEGER, _ingredienttype_id INTEGER) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
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