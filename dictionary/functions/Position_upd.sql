CREATE OR REPLACE FUNCTION dictionary.position_upd(_data JSON) RETURNS JSON
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _position_id INTEGER;
    _name        VARCHAR(100);
    _salary      NUMERIC(15, 2);
BEGIN
    SELECT s.position_id,
           s.name,
           s.salary
    INTO _position_id,
         _name,
         _salary
    FROM JSON_TO_RECORDSET(_data) AS s (position_id INTEGER,
                                        name        VARCHAR(100),
                                        salary      NUMERIC(15, 2));


    INSERT INTO dictionary.position AS ins (position_id,
                                            name,
                                            salary)
    SELECT _position_id,
           _name,
           _salary
    ON CONFLICT (position_id) DO UPDATE
        SET salary = excluded.salary;

    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;