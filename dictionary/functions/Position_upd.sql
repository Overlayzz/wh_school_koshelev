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
    SELECT COALESCE(p.position_id, NEXTVAL('dictionary.position_position_id_seq')) AS position_id,
           s.name,
           s.salary
    INTO _position_id,
         _name,
         _salary
    FROM JSON_TO_RECORD(_data) AS s (position_id INTEGER,
                                     name        VARCHAR(100),
                                     salary      NUMERIC(15, 2))
             LEFT JOIN dictionary.position p ON p.position_id = s.position_id;

    IF EXISTS(SELECT 1
              FROM dictionary.position pos
              WHERE pos.position_id = _position_id
                AND pos.name = _name)
    THEN
        RETURN public.errmessage('dictionary.position_upd.duplicate',
                                 'Такая запись уже существует!',
                                 '');
    END IF;

    INSERT INTO dictionary.position AS ins (position_id,
                                            name,
                                            salary)
    SELECT _position_id,
           _name,
           _salary
    ON CONFLICT (position_id) DO UPDATE
        SET name   = excluded.name,
            salary = excluded.salary;

    RETURN JSON_BUILD_OBJECT('data', NULL);
END
$$;