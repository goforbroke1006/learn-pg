BEGIN; -- 2

-- SET lock_timeout = 30000; -- 4
-- SET statement_timeout = 10000; -- 4
SET deadlock_timeout = 30000; -- 4

ALTER TABLE account
    ADD COLUMN fake_column VARCHAR(255)
        DEFAULT 'Hello, World!!!'; -- 7

SET lock_timeout = 0; -- 12

ROLLBACK ; -- 13