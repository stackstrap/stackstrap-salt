#
# StackStrap auto provisioning module for dev (vagrant environments)
# 
# Copyright 2013 FatBox Inc
#

# first split our minion id by dashes (which should look like user-2-project-19)
{% set id_parts = opts['id'].split('-') %}

# now include the state for the project by using the last two parts of the id
# in the example above this would become: project-19
include:
  - {{ id_parts[-2] }}-{{ id_parts[-1] }}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
