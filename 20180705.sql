-- 查看mysql数据文件存储位置
show global variables like "%datadir%";

-- 个命令是全局读锁定，执行了命令之后所有库所有表都被锁定只读。一般都是用在数据库联机备份，这个时候数据库的写操作将被阻塞，读操作顺利进行。 
FLUSH TABLES WITH READ LOCK

-- 解锁语句是
UNLOCK TABLES;

-- 这个命令是表级别的锁定，可以定制锁定某一个表。例如： lock  tables test read; 不影响其他表的写操作。
LOCK TABLES tbl_name [AS alias] {READ [LOCAL] | [LOW_PRIORITY] WRITE}

-- 解锁语句是
UNLOCK TABLES;

--UNION 操作符用于合并两个或多个 SELECT 语句的结果集。
--请注意，UNION 内部的 SELECT 语句必须拥有相同数量的列。列也必须拥有相似的数据类型。同时，每条 SELECT 语句中的列的顺序必须相同。
SELECT column_name(s) FROM table_name1
UNION
SELECT column_name(s) FROM table_name2

--注释：默认地，UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。
SELECT column_name(s) FROM table_name1
UNION ALL
SELECT column_name(s) FROM table_name2
--另外，UNION 结果集中的列名总是等于 UNION 中第一个 SELECT 语句中的列名。

