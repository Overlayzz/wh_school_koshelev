CREATE OR REPLACE FUNCTION humanresource.client_upd(_data jsonb, _employee_id INT) RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _client_id   INTEGER;
    _name        VARCHAR(200);
    _phone       VARCHAR(11);
    _card_number VARCHAR(16);
    _dt          TIMESTAMPTZ := NOW();
BEGIN
    SET TIME ZONE 'Europe/Moscow';
    SELECT COALESCE(c.client_id, NEXTVAL('humanresource.humanresourcesq')) AS client_id,
           s.name,
           s.phone,
           s.card_number
    INTO _client_id,
         _name,
         _phone,
         _card_number
    FROM JSONB_TO_RECORD(_data) AS s (client_id   INT,
                                      name        VARCHAR(30),
                                      phone       VARCHAR(11),
                                      card_number VARCHAR(16))
             LEFT JOIN humanresource.client c ON c.client_id = s.client_id;

    IF EXISTS(SELECT 1
              FROM humanresource.client c
              WHERE c.client_id   = _client_id
                AND c.phone       = _phone
                AND c.card_number = _card_number)
    THEN
        RETURN public.errmessage('humanresource.client_upd.duplicate', 'Такая запись уже существует!', '');
    END IF;

    WITH ins_cte AS (
        INSERT INTO humanresource.client AS c (client_id,
                                               name,
                                               phone,
                                               card_number,
                                               ch_dt,
                                               ch_employee_id)
            SELECT _client_id,
                   _name,
                   _phone,
                   _card_number,
                   _dt,
                   _employee_id
            ON CONFLICT (client_id) DO UPDATE
                SET name           = excluded.name,
                    phone          = excluded.phone,
                    card_number    = excluded.card_number,
                    ch_dt          = excluded.ch_dt,
                    ch_employee_id = excluded.ch_employee_id
                WHERE c.ch_dt <= excluded.ch_dt
            RETURNING c.*)

    INSERT INTO history.clientchanges (client_id,
                                       name,
                                       phone,
                                       card_number,
                                       ch_dt,
                                       ch_employee_id)
    SELECT ins.client_id,
           ins.name,
           ins.phone,
           ins.card_number,
           ins.ch_dt,
           ins.ch_employee_id
    FROM ins_cte ins;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;