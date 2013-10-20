#
# StackStrap Master SLS
# This state sets up a machine to run the StackStrap master application
# 
# Copyright 2013 FatBox Inc
#

include:
  - uwsgi
  - nginx
  - virtualenv
  - postgres

{% from "utils/users.sls" import skeleton %}
{% from "postgres/macros.sls" import postgres_user_db %}
{% from "nginx/macros.sls" import nginxsite %}
{% from "uwsgi/macros.sls" import uwsgiapp %}

{{ skeleton("stackstrap", 6000, 6000) }}
{{ postgres_user_db("stackstrap") }}

# setup an nginx site on the specified pillar, or use "_" if one doesn't exist
# so that we catch all traffic
#
# TODO: SSL 
{{ nginxsite("stackstrap-master", "stackstrap", "stackstrap",
    server_name=pillar.get('stackstrap', {}).get('http_server_name', '_'),
    template="uwsgi-django.conf",
    root=None,
    create_root=False,
    defaults={
      'listen': pillar.get('stackstrap', {}).get('http_listen', '80'),
      'port': 6000,
    }
) }}

{{ uwsgiapp("stackstrap", "/home/stackstrap/virtualenv", "stackstrap", "stackstrap",
            "/application/stackstrap", "127.0.0.1:6000", "stackstrap/wsgi.py",
            "DJANGO_SETTINGS_MODULE=stackstrap.settings.%s" % pillar.get('stackstrap', {}).get('settings', 'dev'),
            reload=True
) }}

stackstrap_env:
  virtualenv:
    - managed
    - name: /home/stackstrap/virtualenv
    - requirements: /application/requirements/{{ pillar.get('stackstrap', {}).get('requirements', 'base') }}.txt
    - user: stackstrap
    - system_site_packages: True
    - require:
      - user: stackstrap
      - pkg: virtualenv_pkgs

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
