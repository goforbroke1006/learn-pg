-- CREATE OR REPLACE FUNCTION partition_create(main_table varchar,
--                                             partition_name varchar,
--                                             constraint_name varchar,
--                                             constraint_rule varchar) RETURNS int AS
-- $func$
--     DECLARE
--         quantity integer DEFAULT 0;    
-- BEGIN
--     
--     
-- --     quantity := (SELECT COUNT(1)
-- --         FROM information_schema.tables
-- --         WHERE table_schema = 'public'
-- --                                  AND table_name = partition_name);
-- 
--     IF quantity == 0 THEN
--         EXECUTE format('CREATE TABLE IF NOT EXISTS %s ( LIKE %s INCLUDING ALL );', partition_name, main_table);
--         EXECUTE format('ALTER TABLE %s ADD CONSTRAINT %s CHECK (%s);', partition_name, constraint_name,
--                        constraint_rule);
--         EXECUTE format('ALTER TABLE %s INHERIT %s;', partition_name, main_table);
--         SELECT pg_sleep(12000);
--     END IF;
--     RETURN 1;
-- EXCEPTION
--     WHEN query_canceled THEN
--         RAISE NOTICE 'caught query_canceled';
--         RETURN 0;
-- END;
-- $func$
--     LANGUAGE plpgsql;


BEGIN; -- 3
SET LOCAL statement_timeout = 10000; -- 3
CREATE TABLE IF NOT EXISTS account_2020_04_22
(
    LIKE account INCLUDING ALL
); -- 3
ALTER TABLE account_2020_04_22
    ADD CONSTRAINT received_at_check
        CHECK (owner_id >= 1000 AND owner_id < 2000); -- 3
ALTER TABLE account_2020_04_22
    INHERIT account; -- 3
SELECT pg_sleep(12000); -- 3

SET LOCAL statement_timeout = 0; -- 3

COMMIT; -- 3


SET LOCAL statement_timeout = 0; -- 5
SHOW statement_timeout; -- 5


SELECT COUNT(1)
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name = 'account_2020_04_22'; -- 6
