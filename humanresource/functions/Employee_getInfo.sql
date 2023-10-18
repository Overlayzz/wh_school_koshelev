CREATE OR REPLACE FUNCTION humanresource.employee_getinfo(_data JSONB DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _employee_id INTEGER DEFAULT NULL;
    _phone       VARCHAR(11) DEFAULT NULL;
    _position_id INTEGER DEFAULT NULL;
BEGIN
    SELECT s.employee_id,
           s.phone,
           s.position_id
    INTO _employee_id,
         _phone,
         _position_id
    FROM JSONB_TO_RECORD(_data) AS s (employee_id INTEGER,
                                      phone       VARCHAR(11),
                                      position_id INTEGER);

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT emp.employee_id,
                     emp.name,
                     emp.phone,
                     emp.birth,
                     emp.position_id,
                     emp.is_delete
              FROM humanresource.employee emp
              WHERE emp.employee_id = COALESCE(_employee_id, emp.employee_id)
                AND emp.phone       = COALESCE(_phone, emp.phone)
                AND emp.position_id = COALESCE(_position_id, emp.position_id)
              ) res;
END
$$;