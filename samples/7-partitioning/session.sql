-- --------------------------------------------------
-- PARTITIONING DECLARATIVE
-- https://postgrespro.ru/docs/postgresql/10/ddl-partitioning#DDL-PARTITIONING-DECLARATIVE
-- --------------------------------------------------

-- CREATE TABLE measurement
-- (
--     city_id   int  not null,
--     logdate   date not null,
--     peaktemp  int,
--     unitsales int
-- ) PARTITION BY RANGE (logdate);
--
-- CREATE TABLE measurement_y2006m02 PARTITION OF measurement
--     FOR VALUES FROM ('2006-02-01') TO ('2006-03-01');
--
-- CREATE TABLE measurement_y2006m03 PARTITION OF measurement
--     FOR VALUES FROM ('2006-03-01') TO ('2006-04-01');
--
--
-- INSERT INTO measurement
-- VALUES (1, '2006-02-22 12:00:00', 42, 1234567890),
--        (2, '2006-03-13 15:00:00', -15, 12);
--
-- DROP TABLE measurement;


-- --------------------------------------------------
-- PARTITIONING IMPLEMENTATION INHERITANCE
-- https://postgrespro.ru/docs/postgresql/10/ddl-partitioning#DDL-PARTITIONING-IMPLEMENTATION-INHERITANCE
-- --------------------------------------------------

CREATE TABLE measurement
(
    city_id   int  not null,
    logdate   date not null,
    peaktemp  int,
    unitsales int
);

CREATE TABLE measurement_y2006m02
(
    CHECK ( logdate >= DATE '2006-02-01' AND logdate < DATE '2006-03-01' )
) INHERITS (measurement);
CREATE INDEX measurement_y2006m02_logdate ON measurement_y2006m02 (logdate);

CREATE TABLE measurement_y2006m03
(
    CHECK ( logdate >= DATE '2006-03-01' AND logdate < DATE '2006-04-01' )
) INHERITS (measurement);
CREATE INDEX measurement_y2006m03_logdate ON measurement_y2006m03 (logdate);

CREATE OR REPLACE FUNCTION measurement_insert_trigger()
    RETURNS TRIGGER AS
$$
DECLARE
    m_year     INTEGER;
    m_month    INTEGER;
    table_name VARCHAR;
BEGIN
    m_year := extract(YEAR FROM NEW.logdate);
    m_month := extract(MONTH FROM NEW.logdate);
    table_name := 'measurement_y' || m_year || 'm' || LPAD(m_month::text, 2, '0');

    RAISE NOTICE 'will use table %', table_name;

    EXECUTE 'INSERT INTO ' || table_name || ' VALUES ($1.*)' USING NEW;
    RETURN NULL;
END
$$
    LANGUAGE plpgsql;

CREATE TRIGGER insert_measurement_trigger
    BEFORE INSERT ON measurement
    FOR EACH ROW EXECUTE PROCEDURE measurement_insert_trigger();

INSERT INTO measurement
VALUES (1, '2006-02-22 12:00:00', 42, 1234567890),
       (2, '2006-03-13 15:00:00', -15, 12);


SET constraint_exclusion = off;
EXPLAIN SELECT count(*) FROM measurement
        WHERE logdate >= DATE '2008-01-01';
-- Aggregate  (cost=59.85..59.86 rows=1 width=8)
--            ->  Append  (cost=0.00..56.61 rows=1296 width=0)
--         ->  Seq Scan on measurement  (cost=0.00..3.31 rows=62 width=0)
--               Filter: (logdate >= '2008-01-01'::date)
--         ->  Bitmap Heap Scan on measurement_y2006m02  (cost=8.93..26.65 rows=617 width=0)
--               Recheck Cond: (logdate >= '2008-01-01'::date)
--               ->  Bitmap Index Scan on measurement_y2006m02_logdate  (cost=0.00..8.78 rows=617 width=0)
--                     Index Cond: (logdate >= '2008-01-01'::date)
--         ->  Bitmap Heap Scan on measurement_y2006m03  (cost=8.93..26.65 rows=617 width=0)
--               Recheck Cond: (logdate >= '2008-01-01'::date)
--               ->  Bitmap Index Scan on measurement_y2006m03_logdate  (cost=0.00..8.78 rows=617 width=0)
--                     Index Cond: (logdate >= '2008-01-01'::date)

SET constraint_exclusion = on;
EXPLAIN SELECT count(*) FROM measurement
        WHERE logdate >= DATE '2008-01-01';
-- Aggregate  (cost=3.47..3.48 rows=1 width=8)
--            ->  Append  (cost=0.00..3.31 rows=62 width=0)
--         ->  Seq Scan on measurement  (cost=0.00..3.31 rows=62 width=0)
--               Filter: (logdate >= '2008-01-01'::date)

SET constraint_exclusion = partition; -- set to default


-- drop table and data
-- DROP TABLE measurement_y2006m02;

-- un-inherit and keep data
-- ALTER TABLE measurement_y2006m02 NO INHERIT measurement;