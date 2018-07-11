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
