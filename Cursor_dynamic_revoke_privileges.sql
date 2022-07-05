create table public.data_permissions
(grantee char(255), table_name char(255), privilege_type char(255), actions char(255))
COPY characters FROM 'C:\a\characters.csv' DELIMITER ',' CSV HEADER;

create or replace function apply_query(create_vew text ) returns void as $$
begin 
		execute create_vew;
end
$$ language PLPGSQL;


DECLARE
    curs CURSOR FOR SELECT grantee,table_name,privilege_type FROM public.data_permissions
	WHERE actions = 'delete';
	
	_grantee char(255);
	_table_name char(255);
	_privilege_type char(255);
BEGIN
OPEN curs;
LOOP
fetch curs into _grantee,_table_name,_privilege_type;
IF NOT FOUND THEN EXIT;END IF;

select apply_query('REVOKE '+_privilege_type+ ' ON '+_table_name +'FROM _grantee')

end loop;
close curs;

