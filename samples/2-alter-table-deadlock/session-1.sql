BEGIN; -- 1


SELECT suspended
FROM account
WHERE owner_id = 444
    FOR UPDATE; -- 4




SELECT *
FROM account; -- 7


UPDATE account
SET suspended = true
WHERE owner_id = 444; -- 9

COMMIT; -- 11