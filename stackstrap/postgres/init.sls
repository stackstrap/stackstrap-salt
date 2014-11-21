#
# PostgreSQL SLS file
# Install and manage PostgreSQL
# 
# Copyright 2014 Evan Borgstrom
#

{% from "stackstrap/postgres/map.jinja" import postgres with context %}

postgres:
  pkg:
    - installed
    - name: {{ postgres.package_server }}

  service:
    - running
    - name: {{ postgres.service }}
    - require:
      - pkg: postgres

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
