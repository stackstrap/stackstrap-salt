#
# Supervisor state file
# 
# Copyright 2014 Evan Borgstrom
#

supervisor_requirements:
  pkg:
    - installed
    - names:
      - python-pip

supervisor:
  pip:
    - installed
    - require:
      - pkg: supervisor_requirements


# vim: set ft=yaml ts=2 sw=2 et sts=2 :
