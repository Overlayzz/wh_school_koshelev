CREATE OR REPLACE FUNCTION dictionary.position_getinfo(_position_id INTEGER) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT pos.position_id,
                     pos.name,
                     pos.salary
              FROM dictionary.position pos
              WHERE pos.position_id = COALESCE(_position_id, pos.position_id)) res;
END
$$;