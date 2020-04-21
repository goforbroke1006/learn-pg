SELECT c.relname, l.mode, l.granted, l.pid
FROM pg_locks as l
         JOIN pg_class as c on c.oid = l.relation; -- 0

SELECT c.relname, l.mode, l.granted, l.pid
FROM pg_locks as l
         JOIN pg_class as c on c.oid = l.relation; -- 3


SELECT c.relname, l.mode, l.granted, l.pid
FROM pg_locks as l
         JOIN pg_class as c on c.oid = l.relation; -- 6


SELECT c.relname, l.mode, l.granted, l.pid
FROM pg_locks as l
         JOIN pg_class as c on c.oid = l.relation; -- 9


SELECT c.relname, l.mode, l.granted, l.pid
FROM pg_locks as l
         JOIN pg_class as c on c.oid = l.relation; -- 11