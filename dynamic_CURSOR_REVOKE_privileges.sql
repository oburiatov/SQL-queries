CREATE TABLE public.data_permissions (
	grantee char(255),
	table_name char(255),
	privilege_type char(255),
	actions char(255)
) COPY characters
FROM
	'C:\a\characters.csv' DELIMITER ',' CSV HEADER;
CREATE
OR REPLACE FUNCTION apply_query(create_vew TEXT) RETUNRS void AS $ $ BEGIN EXECUTE create_vew;
END $ $ LANGUAGE PLPGSQL;
DECLARE curs CURSOR FOR
SELECT
	grantee,
	table_name,
	privilege_type
FROM
	public.data_permissions
WHERE
	actions = 'delete';
_grantee char(255);
_table_name char(255);
_privilege_type char(255);
BEGIN OPEN curs;
LOOP FETCH curs INTO _grantee,
_table_name,
_privilege_type;
IF NOT FOUND THEN EXIT;
END IF;
SELECT
	apply_query(
		'REVOKE ' + _privilege_type + ' ON ' + _table_name + 'FROM _grantee'
	)
END LOOP;
CLOSE curs;