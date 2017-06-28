steps:https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-centos-7
1. install mysql
# wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
# sudo rpm -ivh mysql57-community-release-el7-9.noarch.rpm
# sudo yum install mysql-server

2. starting mysql
# sudo systemctl start mysqld
# sudo systemctl status mysqld
# sudo grep 'temporary password' /var/log/mysqld.log

3. configuring mysql
# sudo mysql_secure_installation

4. testing mysql
# mysqladmin -u root -p version


Q1:ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
> set password=password('123456789');

Q2:ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
> SET GLOBAL  validate_password_policy='LOW';
