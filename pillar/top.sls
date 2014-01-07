#
# Pillar top file
# 
# Copyright 2014 Evan Borgstrom
#

base:
  '*':
    - packages
    - services

  '^project-(\d+)$':
    - match: pcre
    - stackstrap.auto.dev


# vim: set ft=yaml ts=2 sw=2 et sts=2 :
