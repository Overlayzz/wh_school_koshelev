CREATE OR REPLACE FUNCTION dictionary.ingredienttype_getinfo(_data JSONB DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _ingredienttype_id INTEGER DEFAULT NULL;
    _storageblock_id   INTEGER DEFAULT NULL;
BEGIN
    SELECT s.ingredienttype_id,
           s.storageblock_id
    INTO _ingredienttype_id,
         _storageblock_id
    FROM JSONB_TO_RECORD(_data) AS s (ingredienttype_id INTEGER,
                                      storageblock_id   INTEGER);

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