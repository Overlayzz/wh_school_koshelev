CREATE OR REPLACE FUNCTION dictionary.position_upd(_data JSON) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _name        VARCHAR(100);
    _salary      NUMERIC(15, 2);
BEGIN
    SELECT s.name,
           s.salary
    INTO _name,
         _salary
    FROM JSON_TO_RECORDSET(_data) AS s (name   VARCHAR(100),
                                        salary NUMERIC(15, 2));

    INSERT INTO dictionary.position AS ins (name,
                                            salary)
    SELECT _name,
           _salary;
    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;