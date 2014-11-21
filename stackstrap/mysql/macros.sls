#
# MySQL Macros SLS module
# 
# Copyright 2014 Evan Borgstrom
#

{% macro mysql_user_db(name, password) -%}
{{ name }}_mysql_user_db:
  mysql_database:
    - present
    - name: {{ name }}

  mysql_user:
    - present
    - name: {{ name }}
    - password: '{{ password }}'
    - host: 'localhost'

  mysql_grants:
    - present
    - name: {{ name }}
    - grant: all privileges
    - database: '{{ name }}.*'
    - user: {{ name }}
    - host: 'localhost'
    - require:
      - mysql_user: {{ name }}
      - mysql_database: {{ name }}
{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
