BEGIN;                                      -- 3
SHOW transaction_isolation;                 -- 4

SELECT * FROM account WHERE id = 1;         -- 6
SELECT * FROM account WHERE id = 1;         -- 8
SELECT * FROM account WHERE id = 1;         -- 10

-- <-- 11

SELECT * FROM account WHERE id = 1;         -- 12

COMMIT;                                     -- 14

SELECT * FROM account WHERE id = 1;         -- 15