#
# Package pillars
#
# New packages should have a leading comment and then, if needed, use a
# conditional statement to target the different os_family or os grains.
#
# Things should be organized alphabetically
# 
# Copyright 2013 FatBox Inc
#

pkg:

# Nginx
  nginx: 'nginx'
{% if grains['os_family'] == 'RedHat' %}
  nginx_default: '/etc/nginx/conf.d/default.conf'
{% elif grains['os_family'] == 'Debian' %}
  nginx_default: '/etc/nginx/sites-enabled/default'
{% endif %}

# PostgreSQL
{% if grains['os_family'] == 'RedHat' %}
  postgres: 'postgresql-server'
{% else %}
  postgres: 'postgresql'
{% endif %}

# Python Virtualenv
  python_virtualenv: 'python-virtualenv'
  python_pip: 'python-pip'

# uWSGI
  uwsgi: 

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
