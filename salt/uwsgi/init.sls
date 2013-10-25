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
  pip:
    - installed
    - pkgs:
        uwsgi
    - require:
      - pkg: uwsgi_requirements

  service:
    - running
    - enable: True
    - require:
      - pip: uwsgi

/usr/lib/uwsgi/plugins:
  file:
    - directory
    - owner: root
    - group: root
    - mode: 755
    - makedirs: True

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
