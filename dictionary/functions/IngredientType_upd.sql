CREATE OR REPLACE FUNCTION dictionary.ingredienttype_upd(_data json) RETURNS json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _name            VARCHAR(100);
    _storageblock_id INTEGER;
BEGIN
    SELECT s.name,
           s.storageblock_id
    INTO _name,
         _storageblock_id
    FROM JSON_TO_RECORDSET(_data) AS s (name            VARCHAR(100),
                                        storageblock_id INTEGER);

    INSERT INTO dictionary.ingredienttype AS ins (name,
                                                  storageblock_id)
    SELECT _name,
           _storageblock_id;
    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;