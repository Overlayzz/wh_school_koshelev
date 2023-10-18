CREATE OR REPLACE FUNCTION restaurant.purchase_getinfo(_data JSONB DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _purchase_id INTEGER DEFAULT NULL;
    _supplier_id INTEGER DEFAULT NULL;
    _is_approved BOOLEAN DEFAULT NULL;
BEGIN
    SELECT s.purchase_id,
           s.supplier_id,
           s.is_approved
    INTO _purchase_id,
         _supplier_id,
         _is_approved
    FROM JSONB_TO_RECORD(_data) AS s (purchase_id INTEGER,
                                      supplier_id INTEGER,
                                      is_approved BOOLEAN);

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT p.purchase_id,
                     p.details,
                     p.supplier_id,
                     p.is_approved,
                     p.order_date,
                     p.delivery_date
              FROM restaurant.purchase p
              WHERE p.purchase_id = COALESCE(_purchase_id, p.purchase_id)
                AND p.supplier_id = COALESCE(_supplier_id, p.supplier_id)
                AND p.is_approved = COALESCE(_is_approved, p.is_approved)
              ) res;
END
$$;