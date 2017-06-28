TPCC-MYSQL benchmark on mysql

1. install tpcc-mysql
$ git clone https://github.com/Percona-Lab/tpcc-mysql
$ cd tpcc-mysql/src
$ make

2.create database and load data
	2.1 create database TPCC
	$ mysql -uroot -p -e "CREATE DATABASE TPCC DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
	2.2 initialize table structure
	$ mysql -uroot -p TPCC <./create_table.sql
	2.3 create index and primary key
	$ mysql -uroot -p TPCC <./add_fkey_idx.sql
	2.4 show tables
	$mysql -uroot -p -e "show tables from  TPCC"

	2.5 load data
		2.5.1 single thread
		$./tpcc_load -h 127.0.0.1 -P 3306 -d TPCC -u root -p 000000 -w 10
		2.5.2 concurrency
			$./load.sh TPCC 10 //load 10 warehouse
			or use a script in  https://gist.github.com/sh2/3458844

3.run workload

$./tpcc_start --help
***************************************
*** ###easy### TPC-C Load Generator ***
***************************************
./tpcc_start: invalid option -- '-'
Usage: tpcc_start -h server_host -P port -d database_name -u mysql_user -p mysql_password -w warehouses -c connections -r warmup_time -l running_time -i report_interval -f report_file -t trx_file

$./tpcc_start -h127.0.0.1 -P3306 -d TPCC -u root -p 000000 -w 10 -c 10 -r 120 -l 120 >> mysql_tpcc_20160411



 
