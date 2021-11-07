### Index plans

| Node name | Description |
|-----------|--------------|
| Seq Scan            | Open table, read all rows |
| Index Scan          |  |
| Index Cond          | Check some condition (compare less-or-equal for example) on indexed column.  |
| Index Scan Backward | Scans over index by descending |
| Index Only Scan     | Read data from indexed columns only, PG can return data from index and should not read table         |
| Bitmap Index Scan   | Prepare bits mask (bits array), check all table's pages and set bit=1 if page consists expected rows |
| Bitmap Heap Scan    | Use bit mask to scan marked pages                                                                    |


### Useful links

* https://postgrespro.ru/docs/postgresql/10/functions-admin#FUNCTIONS-ADMIN-DBOBJECT
* https://postgrespro.ru/docs/postgresql/10/pageinspect
