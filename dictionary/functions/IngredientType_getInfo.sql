CREATE OR REPLACE FUNCTION dictionary.ingredienttype_getinfo(_ingredienttype_id INTEGER, _storageblock_id INTEGER) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT ing.ingredienttype_id,
                     ing.storageblock_id,
                     ing.name
              FROM dictionary.ingredienttype ing
              WHERE ing.ingredienttype_id = COALESCE(_ingredienttype_id, ing.ingredienttype_id)
                AND ing.storageblock_id   = COALESCE(_storageblock_id, ing.storageblock_id)
              ) res;
END
$$;