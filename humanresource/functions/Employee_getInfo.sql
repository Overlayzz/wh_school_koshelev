CREATE OR REPLACE FUNCTION humanresource.employee_getinfo(_employee_id INTEGER, _phone VARCHAR(11), _position_id INTEGER) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
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