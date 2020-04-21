CREATE TABLE IF NOT EXISTS account
(
    id         SERIAL,
    currency   VARCHAR(24)    NOT NULL,
    owner_id   BIGINT         NOT NULL,
    owner_name VARCHAR(1024)  NOT NULL,
    balance    DECIMAL(24, 4) NOT NULL,
    suspended  BOOL DEFAULT false,

    PRIMARY KEY (id)
);

