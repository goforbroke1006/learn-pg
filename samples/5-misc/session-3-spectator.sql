SELECT c.relname, l.mode, l.granted, l.pid
FROM pg_locks as l
         JOIN pg_class as c on c.oid = l.relation;