#
# Macros for working with users
# 
# Copyright 2013 FatBox Inc
#

{#
 # skeleton sets up a group, user & home dirs
 #}
{% macro skeleton(name, uid, gid, password=None) -%}
{{ name }}:
  group:
    - present
    - gid: {{ gid }}

  user:
    - present
    - uid: {{ uid }}
    - gid: {{ gid }}
    - shell: /bin/bash
    - home: /home/{{ name }}{% if password %}
    - password: '{{ password }}'{% endif %}
    - require:
      - group: {{ name }}

{{ name }}-dirs:
  file:
    - directory
    - user: {{ name }}
    - group: {{ name }}
    - mode: 755
    - require:
      - user: {{ name }}
    - names:
      - /home/{{ name }}
      - /home/{{ name }}/domains
{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
