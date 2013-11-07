#
# PHP5 macros SLS module
# 
# Copyright 2013 FatBox Inc
#

{% macro php5_fpm_instance(name, port, user, group) -%}
/etc/php5/fpm/pool.d/{{ name }}.conf:
  file:
    - managed
    - owner: root
    - group: root
    - mode: 0644
    - source: salt://php5/files/fpm-template.conf
    - template: jinja
    - defaults:
        name: {{ name }}
        port: {{ port }}
        user: {{ user }}
        group: {{ group }}
    - require:
      - pkg: php5-fpm
      - user: {{ user }}
    - watch_in:
      - service: php5-fpm
{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
