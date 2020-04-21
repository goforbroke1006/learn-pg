BEGIN; -- 3
SET deadlock_timeout = 5000; -- 4

SELECT suspended
FROM account
WHERE owner_id = 888
    FOR UPDATE; -- 4

SELECT suspended
FROM account
WHERE owner_id = 444
    FOR UPDATE;
-- 6

-- wait for reject on timeout

COMMIT; -- 8

SET deadlock_timeout = 1000; -- 10