CREATE OR REPLACE FUNCTION inventory.food_getinfo(_data JSONB DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _food_id     INTEGER DEFAULT NULL;
    _foodtype_id INTEGER DEFAULT NULL;
    _is_delete   BOOLEAN DEFAULT NULL;
BEGIN
    SELECT s.food_id,
           s.foodtype_id,
           s.is_delete
    INTO _food_id,
         _foodtype_id,
         _is_delete
    FROM JSONB_TO_RECORD(_data) AS s (food_id     INTEGER,
                                      foodtype_id INTEGER,
                                      is_delete   BOOLEAN);

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