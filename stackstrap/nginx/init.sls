#
# Nginx SLS
#
# Copyright 2014 Evan Borgstrom
#

{% from "stackstrap/nginx/map.jinja" import nginx with context %}

nginx:
  pkg:
    - installed
    - name: {{ nginx.package }}

  service:
    - running
    - name: {{ nginx.service }}
    - enable: True
    - require:
      - pkg: nginx

{% if nginx.default %}
nginx_default_site:
  file:
    - absent
    - name: {{ nginx.default }}
    - watch_in:
      - service: nginx
{% endif %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
