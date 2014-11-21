#
# Virtualenv SLS
#
# Copyright 2014 Evan Borgstrom
#

{% from "stackstrap/virtualenv/map.jinja" import virtualenv with context %}

virtualenv_pkgs:
  pkg:
    - installed
    - names:
      - {{ virtualenv.package_virtualenv }}
      - {{ virtualenv.package_pip }}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
