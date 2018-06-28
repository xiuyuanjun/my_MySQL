/*备份数据库表*/
/*从数据库查出数据备份到文件中，在去另一个库把文件导入到新库里面*/
SELECT * FROM eums_sms_core.`pre_sign_baobei` INTO OUTFILE "/tmp/pre_sign_baobei.txt";
SELECT * FROM eums_sms_core.`pre_key_words_rule` INTO OUTFILE "/tmp/pre_key_words_rule.txt";
SELECT * FROM eums_sms_core.`pre_key_words_index` INTO OUTFILE "/tmp/pre_key_words_index.txt";
SELECT * FROM eums_sms_core.`pre_key_words_data` INTO OUTFILE "/tmp/pre_key_words_data.txt";
/*同步数据之前先删除旧库当中的数据*/
TRUNCATE TABLE eums_sms_core.`pre_sign_baobei`;
TRUNCATE TABLE eums_sms_core.`pre_key_words_rule`;
TRUNCATE TABLE eums_sms_core.`pre_key_words_index`;
TRUNCATE TABLE eums_sms_core.`pre_key_words_data`;

/*我相信很多同学都遇到过这样的问题
MYSQL导入数据出现The MySQL server is running with the --secure-file-priv option so it cannot execute this statement
方法一：
这个原因其实很简单，是因为在安装MySQL的时候限制了导入与导出的目录权限
只能在规定的目录下才能导入
我们需要通过下面命令查看 secure-file-priv 当前的值是什么*/

show variables like '%secure%';

/*最后将数据文件中的所有的数据导入新的数据库表中*/
LOAD   DATA  LOCAL INFILE '/var/lib/mysql-files/pre_sign_baobei.txt' INTO   TABLE eums_sms_core.`pre_sign_baobei`;
LOAD   DATA  LOCAL INFILE '/var/lib/mysql-files/pre_key_words_rule.txt' INTO   TABLE eums_sms_core.`pre_key_words_rule`;
LOAD   DATA  LOCAL INFILE '/var/lib/mysql-files/pre_key_words_index.txt' INTO   TABLE eums_sms_core.`pre_key_words_index`;
LOAD   DATA  LOCAL INFILE '/var/lib/mysql-files/pre_key_words_data.txt' INTO   TABLE eums_sms_core.`pre_key_words_data`;

/*修改表结构*/
--创建测试表
create table test(
    id int;
);

--add支持多列，change/drop需要在每列前添加关键字，逗号隔开，'column'可有可无

--添加多列
alter table test add (c1 char(1),c2 char(1));   --正确，add支持多列
alter table test add column (c1 char(1),c2 char(1));    --正确
alter table test add c1 char(1),add c2 char(1);     --正确

--修改多列
alter table test change c1 c3 char(1),change c2 c4 char(1);     --正确
alter table test change column c1 c3 char(1),change column c2 c4 char(1);       --正确

alter table test change (c1 c3 char(1),c2 c4 char(1));      --错误

--删除多列
alter table test drop c1,drop c2;   --正确
alter table test drop column c1,drop column c2;     --正确

alter table test drop c1,c2;    --错误
alter table test drop (c1,c2);  --错误


--Mysql 查看连接数,状态 最大并发数(赞
show processlist; 
--如果是root帐号，你能看到所有用户的当前连接。如果是其它普通帐号，只能看到自己占用的连接。 
--show processlist;只列出前100条，如果想全列出请使用
show full processlist; 

show status;
show status like '%下面变量%';
/*
Aborted_clients 由于客户没有正确关闭连接已经死掉，已经放弃的连接数量。 
Aborted_connects 尝试已经失败的MySQL服务器的连接的次数。 
Connections 试图连接MySQL服务器的次数。 
Created_tmp_tables 当执行语句时，已经被创造了的隐含临时表的数量。 
Delayed_insert_threads 正在使用的延迟插入处理器线程的数量。 
Delayed_writes 用INSERT DELAYED写入的行数。 
Delayed_errors 用INSERT DELAYED写入的发生某些错误(可能重复键值)的行数。 
Flush_commands 执行FLUSH命令的次数。 
Handler_delete 请求从一张表中删除行的次数。 
Handler_read_first 请求读入表中第一行的次数。 
Handler_read_key 请求数字基于键读行。 
Handler_read_next 请求读入基于一个键的一行的次数。 
Handler_read_rnd 请求读入基于一个固定位置的一行的次数。 
Handler_update 请求更新表中一行的次数。 
Handler_write 请求向表中插入一行的次数。 
Key_blocks_used 用于关键字缓存的块的数量。 
Key_read_requests 请求从缓存读入一个键值的次数。 
Key_reads 从磁盘物理读入一个键值的次数。 
Key_write_requests 请求将一个关键字块写入缓存次数。 
Key_writes 将一个键值块物理写入磁盘的次数。 
Max_used_connections 同时使用的连接的最大数目。 
Not_flushed_key_blocks 在键缓存中已经改变但是还没被清空到磁盘上的键块。 
Not_flushed_delayed_rows 在INSERT DELAY队列中等待写入的行的数量。 
Open_tables 打开表的数量。 
Open_files 打开文件的数量。 
Open_streams 打开流的数量(主要用于日志记载） 
Opened_tables 已经打开的表的数量。 
Questions 发往服务器的查询的数量。 
Slow_queries 要花超过long_query_time时间的查询数量。 
Threads_connected 当前打开的连接的数量。 
Threads_running 不在睡眠的线程数量。 
Uptime 服务器工作了多少秒。
*/

show variables like '%max_connections%'; --查看最大连接数

--MySQL服务器的线程数需要在一个合理的范围之内，这样才能保证MySQL服务器健康平稳地运行。Threads_created表示创建过的线程数，通过查看Threads_created就可以查看MySQL服务器的进程状态。
show global status like 'Thread%';

--如果我们在MySQL服务器配置文件中设置了thread_cache_size，当客户端断开之后，服务器处理此客户的线程将会缓存起来以响应下一个客户而不是销毁(前提是缓存数未达上限)。
--Threads_created表示创建过的线程数，如果发现Threads_created值过大的话，表明MySQL服务器一直在创建线程，这也是比较耗资源，可以适当增加配置文件中thread_cache_size值，
--查询服务器thread_cache_size配置：
show variables like 'thread_cache_size';

--mysql 中sum (if())
--先来一个简单的sum
select sum(qty) as total_qty from inventory_product group by product_id
--这样就会统计出所有product的qty.
--但是很不幸，我们的系统里面居然有qty为负值。而我只想统计那些正值的qty，加上if function就可以了。 SQL为：
select sum(if(qty > 0, qty, 0)) as total_qty   from inventory_product group by product_id
--意思是如果qty > 0, 将qty的值累加到total_qty, 否则将0累加到total_qty.
--再加强一点：
select
sum( if( qty > 0, qty, 0)) as total_qty   ,
sum( if( qty < 0, 1, 0 )) as negative_qty_count
from inventory_product 
group by product_id



