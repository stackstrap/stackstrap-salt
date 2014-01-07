#
# Nginx SLS
# 
# Copyright 2014 Evan Borgstrom
#

nginx:
  pkg:
    - installed
    - name: {{ pillar['pkg']['nginx'] }}

  service:
    - running
    - name: {{ pillar['svc']['nginx'] }}
    - require:
      - pkg: nginx

{% if 'nginx_default' in pillar['pkg'] %}
nginx_default_site:
  file:
    - absent
    - name: {{ pillar['pkg']['nginx_default'] }}
    - watch_in:
      - service: nginx
{% endif %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
