-- ON the server with data 
CREATE USER ks_dmp85_dmp_dict WITH PASSWORD 'passwd'; --special user for reading data
grant select on dmp.dict.ireg_roaming_partners to ks_dmp85_dmp_dict 
GRANT CONNECT ON DATABASE dmp TO ks_dmp85_dmp_dict 
GRANT USAGE ON SCHEMA dict TO ks_dmp85_dmp_dict 

--ON the server where the query will be running
CREATE SERVER ks_dmp31 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'ks-dmp31.kyivstar.ua', 
dbname 'dmp', port '5432');

CREATE USER MAPPING FOR public SERVER ks_dmp31 OPTIONS(user 'ks_dmp85_dmp_dict', password 'jw8s0F4');
--OR
	CREATE USER MAPPING FOR ks_dmp85_dmp_dict SERVER ks_dmp31 OPTIONS(user 'ks_dmp85_dmp_dict', password 'jw8s0F4');

--follow the original structure of the table
CREATE FOREIGN TABLE dict.ireg_roaming_partners (
    country_cd text NULL,
    country_a3_cd text NULL,
    country_name_en text NULL,
    operator_name_en text NULL,
    cc_nngt_from text NULL,
    cc_nngt_to text NULL
) SERVER ks_dmp31 OPTIONS(schema_name 'dict', table_name 'ireg_roaming_partners');









