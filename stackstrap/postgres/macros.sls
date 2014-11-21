#
# PostgreSQL macros
# 
# Copyright 2014 Evan Borgstrom
#

# postgres_user_db creates a simple user & database with the same name
{% macro postgres_user_db(name, password=None) -%}
{{ name }}_postgres_user_db: 
  postgres_user:
    - present
    - name: {{ name }}{% if password %}
    - password: {{ password }}{% endif %}
    - require:
      - service: postgres

  postgres_database:
    - present
    - owner: {{ name }}
    - name: {{ name }}
    - require:
      - postgres_user: {{ name }}
{%- endmacro %}


# vim: set ft=yaml ts=2 sw=2 et sts=2 :
