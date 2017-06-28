dbt-2 benchmark on mysql
 
1. install dbt-2
# ./configure --with-mysql
Q: configure: error: mysql_config executable notfound
*******************************************************************************
ERROR: cannot find MySQL libraries. If you wantto compile with mysql support,
       youmust either specify file locations explicitly using
      --with-mysql-includes and --with-mysql-libs options, or make sure pathto
      mysql_config is listed in your PATH environment variable. If you want to
      disable MySQL support, use --without-mysql option.
*******************************************************************************

> sudo yum install MySQL-shared  
> sudo yum install MySQL-devel 
> sudo yum install libtool 

# make
# sudo make install

2. create data with datagen
# datagen -w 3 -d  /tmp/dbt2-w3 --mysql
Q: Output directory of data files '/tmp/dbt2-w3' not exists
> mkdir /tmp/dbt2-w3

3. import /tmp/dbt2-w3 into mysql
modify -p in mysql_load_db.sh
if [ "$DB_PASSWORD" != "" ]; then
  #MYSQL_ARGS="-p $DB_PASSWORD"
  MYSQL_ARGS="-p$DB_PASSWORD"

# ./scripts/mysql/mysql_load_db.sh --path /tmp/dbt2-w3/ --host localhost --mysql-path /usr/bin/mysql --user root --password 123456789
Q:ERROR 29 (HY000) at line 1: File '/tmp/dbt2-w3/customer.data' not found (Errcode: 13 - Permission denied)
mysql_load_db.sh中LOAD DATA这个命令引用了变量$LOCAL，但是这个变量并没有值，据http://stackoverflow.com/questions/2221335/access-denied-for-load-data-infile-in-mysql直接使用LOAD
DATA LOCAL INFILE即可。

(insert commnet)
#command_exec "$MYSQL $DB_NAME -e /"LOAD DATA $LOCAL INFILE ///"$DB_PATH/$FN.data///" /
command_exec "$MYSQL $DB_NAME -e /"LOAD DATA LOCAL INFILE ///"$DB_PATH/$FN.data///" /
INTO TABLE $TABLE FIELDS TERMINATED BY '/t' ${COLUMN_NAMES} /""

4. run workload
# ./run_mysql.sh --connections 20 --time 60 --warehouses 3 --host localhost --user root --password 123456789 --lib-client-path /usr/lib64/mysql --output-base /home/ceph/mysql
Q:ERROR: Client was not started. Please look at /home/ceph/mysql/output/1/client.out and /home/ceph/mysql/output/1/client/error.log for details.
Q:mysql reports: 2002 Can't connect to local MySQL server through socket '' (111)
instead localhost with TCP/IP address
> ./run_mysql.sh --connections 20 --time 60 --warehouses 3 --host 127.0.0.1 --user root --password 123456789 --lib-client-path /usr/lib64/mysql --output-base /home/ceph/mysql


5. output is 0
Q:mysql reports SQL STMT: stmt ERROR: 1305 PROCEDURE dbt2.payment does not exist in client/error.log
modify -p in mysql_load_sp.sh
> ./scripts/mysql/mysql_load_sp.sh --database dbt2 --sp-path ./storedproc/mysql/ --client-path /usr/bin/ --user root --password 123456789
then run workload again