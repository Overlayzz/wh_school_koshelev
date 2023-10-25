CREATE OR REPLACE FUNCTION humanresource.employee_upd(_data jsonb,
                                                      _ch_employee_id INTEGER) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _employee_id INTEGER;
    _position_id INTEGER;
    _name        VARCHAR(200);
    _phone       VARCHAR(11);
    _is_delete   BOOLEAN;
    _birth       DATE;
    _dt          TIMESTAMPTZ := NOW();
BEGIN
    SET TIME ZONE 'Europe/Moscow';

    SELECT COALESCE(emp.employee_id, NEXTVAL('humanresource.humanresourcesq')) AS emp_id,
           s.name,
           s.phone,
           s.birth,
           s.position_id,
           COALESCE(s.is_delete, FALSE)                                        AS is_del
    INTO _employee_id,
        _name,
        _phone,
        _birth,
        _position_id,
        _is_delete
    FROM JSONB_TO_RECORD(_data) AS s (employee_id INTEGER,
                                      name        VARCHAR(200),
                                      phone       VARCHAR(11),
                                      birth       DATE,
                                      position_id INTEGER,
                                      is_delete   BOOLEAN)
             LEFT JOIN humanresource.employee emp ON emp.employee_id = s.employee_id;

    WITH ins_cte AS (
        INSERT INTO humanresource.employee AS emp (employee_id,
                                                   name,
                                                   phone,
                                                   birth,
                                                   position_id,
                                                   is_delete,
                                                   ch_dt,
                                                   ch_employee_id)
            SELECT _employee_id,
                   _name,
                   _phone,
                   _birth,
                   _position_id,
                   _is_delete,
                   _dt,
                   _ch_employee_id
            ON CONFLICT (employee_id) DO UPDATE
                SET name           = excluded.name,
                    phone          = excluded.phone,
                    birth          = excluded.birth,
                    position_id    = excluded.position_id,
                    is_delete      = excluded.is_delete,
                    ch_dt          = excluded.ch_dt,
                    ch_employee_id = excluded.ch_employee_id
                WHERE emp.ch_dt <= excluded.ch_dt
            RETURNING emp.*)
    INSERT INTO history.employeechanges (employee_id,
                                         name,
                                         phone,
                                         birth,
                                         position_id,
                                         is_delete,
                                         ch_dt,
                                         ch_employee_id)
    SELECT ins.employee_id,
           ins.name,
           ins.phone,
           ins.birth,
           ins.position_id,
           ins.is_delete,
           ins.ch_dt,
           ins.ch_employee_id
    FROM ins_cte ins;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;