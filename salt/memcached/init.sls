#
# memcached SLS module
# 
# Copyright 2014 Evan Borgstrom
#

memcached:
  pkg:
    - installed

  service:
    - running
    - require:
      - pkg: memcached

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
