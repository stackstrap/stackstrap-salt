#
# StackStrap Master SLS
# This state sets up a machine to run the StackStrap master application
# 
# Copyright 2013 FatBox Inc
#

include:
  - postgres
  - virtualenv

{% from "utils/users.sls" import skeleton %}

{{ skeleton("stackstrap", 6000, 6000) }}

stackstrap-resources:
  postgres_user:
    - present
    - name: stackstrap

  postgres_database:
    - present
    - owner: stackstrap
    - name: stackstrap
    - require:
      - postgres_user: stackstrap

  virtualenv:
    - managed
    - name: /home/stackstrap/virtualenv
    - requirements: /application/requirements.txt
    - user: stackstrap
    - system_site_packages: True
    - require:
      - user: stackstrap
      - pkg: python-virtualenv

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
