#
# Avahi SLS module
# 
# Copyright 2014 Evan Borgstrom
#

{% from "stackstrap/avahi/map.jinja" import avahi with context %}

avahi-daemon:
  pkg:
    - installed
    - name: {{ avahi.package }}

  service:
    - running
    - enable: True
    - require:
      - pkg: avahi-daemon

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
