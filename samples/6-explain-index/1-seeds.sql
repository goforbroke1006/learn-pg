-- clear table before load new data
TRUNCATE payment;

-- repeat this query 4 times to create 1 million rows (execution takes about 1-2 minutes)
WITH gen_series AS (SELECT generate_series(1, 250 * 1000) AS sid)
INSERT
INTO payment (source, destination, amount, comment, kind, attributes)
SELECT (SELECT id FROM wallet WHERE gs.sid IS NOT NULL ORDER BY random() LIMIT 1),
       (SELECT id FROM wallet WHERE gs.sid IS NOT NULL ORDER BY random() LIMIT 1),
       random()::decimal * 1000,
       md5(random()::text),
       (SELECT enum_range(NULL::payment_kind))[(random() * 1000)::int % 3 + 1],
       '{"reason": "...", "is_template": false, "is_periodic": false}'
FROM gen_series gs;

-- should be 1 million rows
SELECT COUNT(*)
FROM payment;