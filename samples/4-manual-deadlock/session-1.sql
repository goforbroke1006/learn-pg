BEGIN; -- 1
SET deadlock_timeout = 5000;
-- 2

-- SHOW deadlock_timeout;

SELECT suspended
FROM account
WHERE owner_id = 444
    FOR UPDATE; -- 3

SELECT suspended
FROM account
WHERE owner_id = 888
    FOR UPDATE;
-- 5

-- wait for reject on timeout

COMMIT; -- 7

SET deadlock_timeout = 1000; -- 9
