#!/bin/sh
# 
# force set mysql root pass
#

{% if grains['os_family'] == 'RedHat' %}
initscript="/etc/init.d/mysqld"
daemon="/usr/libexec/mysqld"
{% else %}
initscript="/etc/init.d/mysql"
daemon="/usr/sbin/mysqld"
{% endif %}

# stop the currently running server
$initscript stop

# start a new copy, skipping the grant table
$daemon --skip-grant-tables --user=root &
sleep 5

# update the password
echo "USE mysql; UPDATE user SET Password=PASSWORD('{{ mysql_root_password }}') WHERE User='root' AND Host='localhost';" | mysql -u root

# shut our new copy down
killall mysqld
sleep 5

# fix perms
chown -R mysql:mysql /var/lib/mysql

# restart via initscript
$initscript start
