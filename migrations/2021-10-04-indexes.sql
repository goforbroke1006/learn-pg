CREATE EXTENSION "uuid-ossp";

CREATE TABLE IF NOT EXISTS wallet
(
    id    UUID PRIMARY KEY,
    title VARCHAR(1024) NOT NULL,
    owner INT           NOT NULL
);

TRUNCATE wallet;

INSERT INTO wallet (id, title, owner)
SELECT uuid_generate_v1(),
       md5(random()::text),
       random()::int
FROM generate_series(1, 1000) AS gs(i);

CREATE TYPE payment_kind AS ENUM ('DEPOSIT', 'WITHDRAW', 'TRANSFER');

CREATE TABLE IF NOT EXISTS payment
(
    id          SERIAL PRIMARY KEY,
    source      UUID           NOT NULL,
    destination UUID           NOT NULL,
    amount      DECIMAL(24, 6) NOT NULL,
    comment     TEXT      DEFAULT NULL,
    kind        payment_kind   NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW(),
    attributes  JSONB     DEFAULT '{}'
);


