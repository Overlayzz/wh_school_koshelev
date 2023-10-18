CREATE OR REPLACE FUNCTION dictionary.foodtype_upd(_data json) RETURNS json
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _name        VARCHAR(100);
BEGIN
    SELECT s.name
    INTO _name
    FROM JSON_TO_RECORDSET(_data) AS s (name VARCHAR(100));

    INSERT INTO dictionary.foodtype AS ins (name)
    SELECT _name;
    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;