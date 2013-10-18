#
# Package pillars
# 
# Copyright 2013 FatBox Inc
#

pkg:

{% if grains['os'] == 'Ubuntu' %}
  postgres: 'postgresql-9.1'
{% endif %}


# vim: set ft=yaml ts=2 sw=2 et sts=2 :
