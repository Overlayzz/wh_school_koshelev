CREATE OR REPLACE FUNCTION restaurant.purchase_getinfo(_purchase_id INTEGER, _supplier_id INTEGER, _is_approved BOOLEAN) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
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