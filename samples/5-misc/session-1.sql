BEGIN; -- 1


SELECT owner_id, suspended
FROM account
WHERE owner_id = 444
    FOR UPDATE; -- 2

COMMIT; -- 4