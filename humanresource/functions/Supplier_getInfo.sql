CREATE OR REPLACE FUNCTION humanresource.supplier_getinfo(_supplier_id INTEGER, _phone VARCHAR(11)) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT sp.supplier_id,
                     sp.name,
                     sp.phone,
                     sp.email,
                     sp.inn
              FROM humanresource.supplier sp
              WHERE sp.supplier_id = COALESCE(_supplier_id, sp.supplier_id)
                AND sp.phone       = COALESCE(_phone, sp.phone)
              ) res;
END
$$;