CREATE OR REPLACE FUNCTION humanresource.client_getinfo(_data JSONB DEFAULT NULL) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _client_id   INTEGER DEFAULT NULL;
    _phone       VARCHAR(11) DEFAULT NULL;
    _card_number VARCHAR(16) DEFAULT NULL;
BEGIN
    SELECT s.client_id,
           s.phone,
           s.card_number
    INTO _client_id,
         _phone,
         _card_number
    FROM JSONB_TO_RECORD(_data) AS s (client_id   INTEGER,
                                      phone       INTEGER,
                                      card_number VARCHAR(16));

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