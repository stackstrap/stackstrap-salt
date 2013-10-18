#
# Service pillars
# 
# Copyright 2013 FatBox Inc
#

svc:

{% if grains['os'] == 'Ubuntu' %}
  postgres: 'postgresql'
{% endif %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
