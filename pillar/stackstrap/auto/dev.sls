#
# Stackstrap auto dev pillar SLS module
# 
# Copyright 2013 FatBox Inc
#

# include the state for the project by using the id of the project
include:
  - {{ opts['id'] }}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
