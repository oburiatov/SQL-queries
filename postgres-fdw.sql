CREATE USER server85_devops_dict WITH PASSWORD 'passwd';
GRANT
SELECT
    ON devops.dict.ireg_roaming_partners TO ks_devops85_devops_dict GRANT CONNECT ON DATABASE db TO server85_devops_dict GRANT USAGE ON SCHEMA dict TO server85_devops_dict --ON the server where the query will be running
    CREATE SERVER ks_devops31 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
        host 'server85_devops_dict',
        dbname 'db',
        port '5432'
    );
CREATE USER MAPPING FOR public SERVER ks_devops31 OPTIONS(user 'server85_devops_dict', PASSWORD '123');

CREATE USER MAPPING FOR server85_devops_dict SERVER ks_devops31 OPTIONS(user 'server85_devops_dict', PASSWORD '123');

CREATE FOREIGN TABLE dict.ireg_roaming_partners (
    country_cd text NULL,
    country_a3_cd text NULL,
    country_name_en text NULL,
    operator_name_en text NULL,
    cc_nngt_from text NULL,
    cc_nngt_to text NULL
) SERVER ks_devops31 OPTIONS(
    schema_name 'dict',
    table_name 'ireg_roaming_partners'
);