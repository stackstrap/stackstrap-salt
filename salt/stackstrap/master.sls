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

{% from "utils/users.sls" import skeleton -%}
{% from "postgres/macros.sls" import postgres_user_db -%}
{% from "nginx/macros.sls" import nginxsite with context -%}
{% from "uwsgi/macros.sls" import uwsgiapp -%}
{% from "supervisor/macros.sls" import supervise -%}

# TODO
python-psycopg2:
  pkg:
    - installed
git:
  pkg:
    - installed


{% set config = grains.get('stackstrap', {}) %}

# set mode so we can use it later
{% set mode = config.get('mode', 'dev') %}

# which nginx template should we use
{% if mode == 'dev' %}
{% set nginx_template = "proxy-django.conf" %}
{% else %}
{% set nginx_template = "uwsgi-django.conf" %}
{% endif %}

{{ skeleton("stackstrap", 6000, 6000) }}
{{ postgres_user_db("stackstrap") }}

# make sure the root user is a member of the saltstack group so that 
# permissive_pki_access will allow us to write to the pki dir
root_in_stackstack_group:
  user:
    - present
    - name: root
    - groups:
      - stackstrap
    - require:
      - group: stackstrap

# set our permissions on /etc/salt/pki
# salt's permission system requires that the top level pki & master
# dirs be 750, but we can make our minions dir 770 so we can write
# to it
stackstrap_salt_dirs_base:
  file:
    - directory
    - group: stackstrap
    - mode: 750
    - require:
      - user: root_in_stackstack_group
    - names:
      - /etc/salt/pki
      - /etc/salt/pki/master

/etc/salt/pki/master/minions:
  file:
    - directory
    - group: stackstrap
    - mode: 770
    - require:
      - file: stackstrap_salt_dirs_base


stackstrap_dirs:
  file:
    - directory
    - user: stackstrap
    - group: stackstrap
    - mode: 750
    - require:
      - user: stackstrap
    - names:
      # private files that need to be outside of a web accessible dir
      - /home/stackstrap/private

      # setup the directory our project specific sls files will live in
      - /home/stackstrap/private/project_states
      - /home/stackstrap/private/project_pillars

      # setup the directory for our project logs
      - /home/stackstrap/logs

# setup an nginx site on the specified config, or use "_" if one doesn't exist
# so that we catch all traffic
{% set http_ssl = config.get('http_ssl', False) %}
{% set http_server_name = config.get('http_server_name', '_') %}
{% if http_ssl %}
{% set http_listen = '443' %}

{{ nginxsite("stackstrap-master", "stackstrap", "stackstrap",
    server_name=http_server_name,
    template="ssl-redirect.conf",
    root=False,
    create_root=False,
    defaults={
      'redirect_http_host': True
    }
) }}
{% else %}
{% set http_listen = '80' %}
{% endif %}

{{ nginxsite("stackstrap-master", "stackstrap", "stackstrap",
    server_name=config.get('http_server_name', '_'),
    template=nginx_template,
    root=False,
    create_root=False,
    ssl=http_ssl,
    listen=http_listen,
    defaults={
      'port': 6000,
      'mode': mode,
      'ssl_certificate': config.get('http_ssl_certificate'),
      'ssl_certificate_key': config.get('http_ssl_certificate_key'),
      'sendfile_off': mode == 'dev',
      'static_path': '/home/stackstrap/static',
      'media_path': '/home/stackstrap/media'
    }
) }}

{% if mode == 'dev' %}
# TODO - run django-admin runserver
{% else %}
{{ uwsgiapp("stackstrap", "stackstrap", "stackstrap", "/home/stackstrap",
            "/home/stackstrap/virtualenv",
            "/home/stackstrap/current/application/stackstrap",
            "127.0.0.1:6000",
            "stackstrap/wsgi.py",
            "DJANGO_SETTINGS_MODULE=stackstrap.settings.%s" % config.get('settings', mode)
) }}
{% endif %}

stackstrap_env:
  virtualenv:
    - managed
    - name: /home/stackstrap/virtualenv
    - requirements: /home/stackstrap/current/application/requirements/{{ config.get('requirements', mode) }}.txt
    - user: stackstrap
    - no_chown: True
    - system_site_packages: True
    - require:
      - user: stackstrap
      - pkg: virtualenv_pkgs

/home/stackstrap/domains/stackstrap-master/static:
  file:
    - symlink
    - target: /home/stackstrap/static
    - owner: stackstrap
    - group: stackstrap

/home/stackstrap/domains/stackstrap-master/media:
  file:
    - symlink
    - target: /home/stackstrap/media
    - owner: stackstrap
    - group: stackstrap

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
