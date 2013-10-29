#
# uWSGI state file
# 
# Copyright 2013 FatBox Inc
#

uwsgi_requirements:
  pkg:
    - installed
    - names:
      - python-dev

uwsgi:
  pkg:
    - installed
    - require:
      - pkg: uwsgi_requirements
    - names:
      - uwsgi
      - uwsgi-plugin-python

  service:
    - running
    - enable: True
    - require:
      - pkg: uwsgi

uwsgi-dirs:
  file:
    - directory
    - owner: root
    - group: root
    - mode: 755
    - makedirs: True
    - names:
      - /usr/lib/uwsgi/plugins

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
