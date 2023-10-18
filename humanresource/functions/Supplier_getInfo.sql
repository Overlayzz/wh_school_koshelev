CREATE OR REPLACE FUNCTION humanresource.supplier_getinfo(_data JSONB DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _supplier_id INTEGER DEFAULT NULL;
    _phone       VARCHAR(11) DEFAULT NULL;
BEGIN
    SELECT s.supplier_id,
           s.phone
    INTO _supplier_id,
         _phone
    FROM JSONB_TO_RECORD(_data) AS s (supplier_id INTEGER,
                                      phone       VARCHAR(11));

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