CREATE OR REPLACE FUNCTION inventory.food_getinfo(_food_id INTEGER, _foodtype_id INTEGER, _is_delete BOOLEAN) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT f.food_id,
                     f.name,
                     f.weight,
                     f.price,
                     f.ingredients,
                     f.is_delete,
                     f.foodtype_id
              FROM inventory.food f
              WHERE f.food_id     = COALESCE(_food_id, f.food_id)
                AND f.foodtype_id = COALESCE(_foodtype_id, f.foodtype_id)
                AND f.is_delete   = COALESCE(_is_delete, f.is_delete)
              ) res;
END
$$;