CREATE OR REPLACE FUNCTION inventory.food_upd(_data jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _food_id     INTEGER;
    _name        VARCHAR(100);
    _weight      INTEGER;
    _price       NUMERIC(15, 2);
    _ingredients JSONB;
    _is_delete   BOOLEAN;
    _foodtype_id INTEGER;
BEGIN
    SELECT COALESCE(f.food_id, NEXTVAL('inventory.inventorysq')) AS fid,
           s.name,
           s.weight,
           s.price,
           s.ingredients,
           COALESCE(s.is_delete, FALSE),
           s.foodtype_id
    INTO _food_id,
         _name,
         _weight,
         _price,
         _ingredients,
         _is_delete,
         _foodtype_id
    FROM JSONB_TO_RECORDSET(_data) AS s (food_id     INTEGER,
                                         name        VARCHAR(100),
                                         weight      INTEGER,
                                         price       NUMERIC(15, 2),
                                         ingredients JSONB,
                                         is_delete   BOOLEAN,
                                         foodtype_id INTEGER)
             LEFT JOIN inventory.food f ON f.food_id = s.food_id;

    INSERT INTO inventory.food AS sup (food_id,
                                       name,
                                       weight,
                                       price,
                                       ingredients,
                                       is_delete,
                                       foodtype_id)
    SELECT _food_id,
           _name,
           _weight,
           _price,
           _ingredients,
           _is_delete,
           _foodtype_id
    ON CONFLICT (food_id) DO UPDATE
        SET food_id     = excluded.food_id,
            name        = excluded.name,
            weight      = excluded.weight,
            price       = excluded.price,
            ingredients = excluded.ingredients,
            is_delete   = excluded.is_delete,
            foodtype_id = excluded.foodtype_id;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;