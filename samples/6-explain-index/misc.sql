-- put "shared_preload_libraries = 'pg_stat_statements'" to postgresql.conf and reload PG
-- SET log_min_duration_statement = 0;
-- SELECT pg_reload_conf();



-- get top 10 slowest SELECT queries
SELECT query, calls, total_time, min_time, max_time, mean_time, stddev_time, rows
FROM public.pg_stat_statements
WHERE query LIKE '%SELECT%'
ORDER BY total_time DESC
LIMIT 10;

--
--

-- get indexes list
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

--
--

-- get info about "payment" table
-- https://postgrespro.ru/docs/postgresql/10/pageinspect
-- https://postgrespro.ru/docs/postgresql/10/functions-admin#FUNCTIONS-ADMIN-DBOBJECT
CREATE EXTENSION pageinspect;
SELECT lower,
       upper,
       special,
       pg_size_pretty(pagesize::bigint),
       pg_relation_size('payment') / pagesize AS pages_count
FROM page_header(get_raw_page('payment', 0));


-- disable/enable Seq Scan
SET enable_seqscan TO off;
SET enable_seqscan TO on;