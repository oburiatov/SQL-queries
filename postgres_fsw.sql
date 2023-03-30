-- ON the server with data 
CREATE USER server85_dmp_dict WITH PASSWORD 'passwd';
--special user for reading data
GRANT
SELECT
    ON dmp.dict.ireg_roaming_partners TO ks_dmp85_dmp_dict GRANT CONNECT ON DATABASE db TO server85_dmp_dict GRANT USAGE ON SCHEMA dict TO server85_dmp_dict --ON the server where the query will be running
    CREATE SERVER ks_dmp31 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
        host 'server85_dmp_dict',
        dbname 'db',
        port '5432'
    );
CREATE USER MAPPING FOR public SERVER ks_dmp31 OPTIONS(user 'server85_dmp_dict', PASSWORD '123');
--OR
CREATE USER MAPPING FOR server85_dmp_dict SERVER ks_dmp31 OPTIONS(user 'server85_dmp_dict', PASSWORD '123');
--follow the original structure of the table
CREATE FOREIGN TABLE dict.ireg_roaming_partners (
    country_cd text NULL,
    country_a3_cd text NULL,
    country_name_en text NULL,
    operator_name_en text NULL,
    cc_nngt_from text NULL,
    cc_nngt_to text NULL
) SERVER ks_dmp31 OPTIONS(
    schema_name 'dict',
    table_name 'ireg_roaming_partners'
);