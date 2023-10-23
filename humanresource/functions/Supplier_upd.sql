CREATE OR REPLACE FUNCTION humanresource.supplier_upd(_data jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _supplier_id INTEGER;
    _name        VARCHAR(100);
    _phone       VARCHAR(11);
    _email       VARCHAR(50);
    _inn         VARCHAR(12);
BEGIN
    SELECT COALESCE(sp.supplier_id, NEXTVAL('humanresource.humanresourcesq')) AS sup_id,
           s.name,
           s.phone,
           s.email,
           s.inn
    INTO _supplier_id,
         _name,
         _phone,
         _email,
         _inn
    FROM JSONB_TO_RECORD(_data) AS s(supplier_id INTEGER,
                                     name        VARCHAR(100),
                                     phone       VARCHAR(11),
                                     email       VARCHAR(50),
                                     inn         VARCHAR(12))
             LEFT JOIN humanresource.supplier sp ON sp.supplier_id = s.supplier_id;

    IF EXISTS(SELECT 1
              FROM humanresource.supplier sp
              WHERE sp.supplier_id = _supplier_id
                AND sp.phone       = _phone)
    THEN
        RETURN public.errmessage('humanresource.supplier_upd.phone_duplicate', 'Этот номер телефона уже есть у поставщика!','');
    END IF;

    INSERT INTO humanresource.supplier AS sup (supplier_id,
                                               name,
                                               phone,
                                               email,
                                               inn)
    SELECT _supplier_id,
           _name,
           _phone,
           _email,
           _inn
    ON CONFLICT (supplier_id, inn) DO UPDATE
        SET supplier_id = excluded.supplier_id,
            name        = excluded.name,
            phone       = excluded.phone,
            email       = excluded.email,
            inn         = excluded.inn;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;