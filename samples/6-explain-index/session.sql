ANALYSE payment;

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
