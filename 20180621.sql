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




