CREATE ROLE prometheus WITH LOGIN PASSWORD 'passwd';
SELECT
    DISTINCT 'GRANT SELECT ON ALL TABLES IN SCHEMA ' || schemaname || ' TO prometheus;'
FROM
    pg_tables;