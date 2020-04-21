BEGIN;                                      -- 1
SHOW transaction_isolation;                 -- 2

SELECT * FROM account WHERE id = 1;         -- 5
UPDATE account SET balance = balance + 100; -- 7
SELECT * FROM account WHERE id = 1;         -- 9

COMMIT;                                     -- 11

SELECT * FROM account WHERE id = 1;         -- # 13