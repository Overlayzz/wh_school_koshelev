CREATE OR REPLACE FUNCTION humanresource.client_getinfo(_client_id   INTEGER,
                                                        _phone       VARCHAR(11),
                                                        _card_number VARCHAR(16)) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT c.client_id,
                     c.name,
                     c.phone,
                     c.card_number
              FROM humanresource.client c
              WHERE c.client_id   = COALESCE(_client_id, c.client_id)
                AND c.phone       = COALESCE(_phone, c.phone)
                AND c.card_number = COALESCE(_card_number, c.card_number)
              ) res;
END
$$;