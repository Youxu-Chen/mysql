steps:https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-centos-7
1. install mysql
$ wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
$ sudo rpm -ivh mysql57-community-release-el7-9.noarch.rpm
$ sudo yum install mysql-server

2. starting mysql
$ sudo systemctl start mysqld
$ sudo systemctl status mysqld
$ sudo grep 'temporary password' /var/log/mysqld.log

3. configuring mysql
$ sudo mysql_secure_installation

4. testing mysql
$ mysqladmin -u root -p version


Q1:ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
> set password=password('123456789');

Q2:ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
> SET GLOBAL  validate_password_policy='LOW';


5. change datadir of mysql
	5.1 shutdown mysql
	$ systemctl stop mysqld.service

	5.2 create new datadir and mv data
	$ mkdir /home/data
	$ mv /var/lib/mysql /home/data

	5.3 modify /etc/my.cnf 
		[mysqld] 
		datadir=/home/data/mysql
		socket=/home/data/mysql/mysql.sock

		[mysql] 
		socket=/home/data/mysql/mysql.sock
	5.4 modify permission
	$ chown -R mysql:mysql /home/data
	$ chmod 777 -R /home/data

	5.5 disable selinux
	$ vim /etc/sysconfig/selinux
	SELINUX=disable

Q:can't connect /mnt/hgfs/mysql_data/mysql.sock(/mnt/hgfs/mysql_data/ is new datadir)
120609 11:31:31 mysqld_safe mysqld from pid file /var/run/mysqld/mysqld.pid ended
120609 11:35:12 mysqld_safe Starting mysqld daemon with databases from /mnt/hgfs/mysql_data
120609 11:35:13 [Warning] Can't create test file /mnt/hgfs/mysql_data/data.lower-test
120609 11:35:13 [Warning] Can't create test file /mnt/hgfs/mysql_data/data.lower-test
/usr/libexec/mysqld: Can't change dir to '/mnt/hgfs/mysql_data/' (Errcode: 13)
120609 11:35:13 [ERROR] Aborting
120609 11:35:13 [Note] /usr/libexec/mysqld: Shutdown complete
120609 11:35:13 mysqld_safe mysqld from pid file /var/run/mysqld/mysqld.pid ended

新的datadir路径确实没问题，而且目录和目录下所有文件都是777权限，上层目录也有rx权限，只不过datadir和下属文件owner都是root（因为我用虚拟机挂载的windows的文件系统）。后来想到应该是selinux搞的鬼，设置为permissive模式之后正常启动mysqld。
复制代码 代码如下:

[root@data selinux]$ getenforce
Enforcing
[root@data selinux]$ setenforce 0
[root@data selinux]$ getenforce
Permissive
setenforce 1 设置SELinux 成为enforcing模式
setenforce 0 设置SELinux 成为permissive模式
彻底关闭，vi /etc/selinux/config 修改 SELINUX=disabled
复制代码 代码如下:

$ This file controls the state of SELinux on the system.
$ SELINUX= can take one of these three values:
$     enforcing - SELinux security policy is enforced.
$     permissive - SELinux prints warnings instead of enforcing.
$     disabled - No SELinux policy is loaded.
SELINUX=disabled
$ SELINUXTYPE= can take one of these two values:
$     targeted - Targeted processes are protected,
$     mls - Multi Level Security protection.
SELINUXTYPE=targeted