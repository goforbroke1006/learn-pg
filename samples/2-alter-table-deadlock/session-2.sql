BEGIN; -- 2

ALTER TABLE account
    ADD COLUMN fake_column VARCHAR(255) DEFAULT 'Hello, World!!!'; -- 6

ROLLBACK; -- 12