#
# Virtualenv SLS
# 
# Copyright 2014 Evan Borgstrom
#

virtualenv_pkgs:
  pkg:
    - installed
    - names:
      - {{ pillar['pkg']['python_virtualenv'] }}
      - {{ pillar['pkg']['python_pip'] }}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
