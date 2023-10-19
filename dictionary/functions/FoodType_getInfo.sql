CREATE OR REPLACE FUNCTION dictionary.foodtype_getinfo(_foodtype_id INTEGER) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT ft.foodtype_id,
                     ft.name
              FROM dictionary.foodtype ft
              WHERE ft.foodtype_id = COALESCE(_foodtype_id, ft.foodtype_id)) res;
END
$$;