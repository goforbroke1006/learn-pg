BEGIN; -- 1


SELECT suspended
FROM account
WHERE owner_id = 444
    FOR UPDATE; -- 5




SELECT *
FROM account; -- 8


UPDATE account
SET suspended = true
WHERE owner_id = 444; -- 10

COMMIT; -- 14