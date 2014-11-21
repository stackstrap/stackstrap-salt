#
# MySQL Sever SLS module
# 
# Copyright 2014 Evan Borgstrom
#

mysql-server:
  pkg:
    - installed

{% if grains['os_family'] == 'Debian' %}
automysqlbackup:
  pkg:
    - installed
{% endif %}

mysql:
  service:
    - running
    - enable: true
    - require:
      - pkg: mysql-server
{% if grains['os_family'] == 'RedHat' %}
    - name: mysqld
  user:
    - present
    - shell: /bin/false
    - home: /var/lib/mysql
    - uid: 27
    - gid: 27
    - require:
      - group: mysql
  group:
    - present
    - gid: 27
  file:
    - directory
    - name: /var/run/mysqld
    - user: mysql
    - group: mysql
    - mode: 700
{% endif %}

# the minion will also need the python mysqldb module
python-mysqldb:
  pkg:
    - installed
{% if grains['os_family'] == 'RedHat' %}
    - name: MySQL-python
{% endif %}

{% set mysql_root_password = salt['pillar.get']('mysql:root_password', '') %}

# configure .my.cnf for root
/root/.my.cnf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - source: salt://stackstrap/mysql/files/root.my.cnf
    - template: jinja
    - defaults:
        mysql_root_password: "{{ mysql_root_password }}"

# create our setmysqlpass.sh script
/root/setmysqlpass.sh:
  file:
    - managed
    - user: root
    - group: root
    - mode: 700
    - source: salt://stackstrap/mysql/files/setmysqlpass.sh
    - template: jinja
    - require:
      - service: mysql
    - defaults:
        mysql_root_password: "{{ mysql_root_password }}"

  cmd:
    - run
    - unless: mysqladmin --defaults-file=/root/.my.cnf -uroot status > /dev/null
    - require:
      - file: /root/setmysqlpass.sh
      - file: /root/.my.cnf

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
