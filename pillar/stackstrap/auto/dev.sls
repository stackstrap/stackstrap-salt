#
# Stackstrap auto dev pillar SLS module
# 
# Copyright 2013 FatBox Inc
#

# first split our minion id by dashes (which should look like user-2-project-19)
{% set id_parts = opts['id'].split('-') %}

# now include the state for the project by using the id of the project
include:
  - project-{{ id_parts[3] }}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
