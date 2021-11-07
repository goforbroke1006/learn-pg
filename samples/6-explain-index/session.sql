ANALYSE payment;
VACUUM payment;

SELECT COUNT(*)
FROM payment;
-- 1000000

SELECT pg_size_pretty(pg_relation_size('payment'));
-- 182 MB

EXPLAIN
SELECT *
FROM payment;
-- Seq Scan on payment  (cost=0.00..33256.00 rows=1000000 width=149)

EXPLAIN (ANALYSE )
SELECT *
FROM payment;
-- Seq Scan on payment  (cost=0.00..33256.00 rows=1000000 width=149) (actual time=0.006..86.078 rows=1000000 loops=1)
-- Planning time: 0.028 ms
-- Execution time: 111.021 ms


EXPLAIN
SELECT *
FROM payment
WHERE amount > 500;
-- Seq Scan on payment  (cost=0.00..35756.00 rows=496199 width=149)
--   Filter: (amount > '500'::numeric)

CREATE INDEX idx_payment_amount ON payment (amount);
ANALYSE payment;

-- https://postgrespro.ru/docs/postgresql/10/functions-admin#FUNCTIONS-ADMIN-DBOBJECT
SELECT pg_size_pretty(pg_indexes_size('payment'));
-- 52 MB

SELECT pg_size_pretty(pg_relation_size('payment_pkey'));
-- 22 MB

SELECT pg_size_pretty(pg_relation_size('idx_payment_amount'));
-- 30 MB


EXPLAIN
SELECT *
FROM payment
WHERE amount > 500;
-- Seq Scan on payment  (cost=0.00..35756.00 rows=497530 width=149)
--   Filter: (amount > '500'::numeric)

EXPLAIN
SELECT *
FROM payment
WHERE amount > 900;
-- Bitmap Heap Scan on payment  (cost=2310.36..26814.65 rows=99863 width=149)
--   Recheck Cond: (amount > '900'::numeric)
--   ->  Bitmap Index Scan on idx_payment_amount  (cost=0.00..2285.40 rows=99863 width=0)
--         Index Cond: (amount > '900'::numeric)

EXPLAIN (ANALYSE )
SELECT *
FROM payment
WHERE amount > 900;
-- Bitmap Heap Scan on payment  (cost=2310.36..26814.65 rows=99863 width=149) (actual time=24.251..147.073 rows=99665 loops=1)
--   Recheck Cond: (amount > '900'::numeric)
--   Heap Blocks: exact=23030
--   ->  Bitmap Index Scan on idx_payment_amount  (cost=0.00..2285.40 rows=99863 width=0) (actual time=20.563..20.563 rows=99665 loops=1)
--         Index Cond: (amount > '900'::numeric)
-- Planning time: 6.897 ms
-- Execution time: 150.402 ms




-- ========== ========== ========== ========== ==========
-- create index for text field
-- ========== ========== ========== ========== ==========

DROP INDEX IF EXISTS idx_payment_comment;
CREATE INDEX idx_payment_comment ON payment (comment);
ANALYSE payment;

EXPLAIN (ANALYSE )
SELECT * FROM payment WHERE comment LIKE 'abc%';
-- Gather  (cost=1000.00..30474.43 rows=10101 width=149) (actual time=0.231..45.467 rows=259 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Seq Scan on payment  (cost=0.00..28464.33 rows=4209 width=149) (actual time=0.757..42.335 rows=86 loops=3)
--         Filter: (comment ~~ 'abc%'::text)
--         Rows Removed by Filter: 333247
-- Planning time: 0.147 ms
-- Execution time: 45.491 ms

-- ========== ========== ========== ========== ==========
-- just "Seq Scan" index does not work because you need "text_pattern_ops" operator
-- ========== ========== ========== ========== ==========

DROP INDEX IF EXISTS idx_payment_comment;
CREATE INDEX idx_payment_comment ON payment (comment text_pattern_ops);
ANALYSE payment;

EXPLAIN (ANALYSE )
SELECT * FROM payment WHERE comment LIKE 'abc%';
-- Bitmap Heap Scan on payment  (cost=10.82..886.46 rows=100 width=149) (actual time=0.083..0.257 rows=259 loops=1)
--   Filter: (comment ~~ 'abc%'::text)
--   Heap Blocks: exact=258
--   ->  Bitmap Index Scan on idx_payment_comment  (cost=0.00..10.80 rows=237 width=0) (actual time=0.059..0.059 rows=259 loops=1)
--         Index Cond: ((comment ~>=~ 'abc'::text) AND (comment ~<~ 'abd'::text))
-- Planning time: 0.178 ms
-- Execution time: 0.279 ms

-- ========== ========== ========== ========== ==========
-- now index work fine
-- ========== ========== ========== ========== ==========
