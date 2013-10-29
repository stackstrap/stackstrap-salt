#
# uWSGI macros
# 
# Copyright 2013 FatBox Inc
#

{% macro uwsgiapp(name, home, user, group, dir, socket, file, env, reload=False, procs=1, enabled=True) %}
uwsgiapp_{{ name }}:
  file:
    - managed
    - name: /etc/uwsgi/apps-available/{{ name }}.ini
    - source: salt://uwsgi/files/template.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 555
    - require:
      - pkg: uwsgi
    - watch_in:
      - service: uwsgi
    - defaults:
        name: {{ name }}
        home: {{ home }}
        user: {{ user }}
        group: {{ group }}
        dir: {{ dir }}
        socket: {{ socket }}
        file: {{ file }}
        env: {{ env }}
        reload: {{ reload }}
        procs: {{ procs }}

uwsgiapp_{{ name }}_enabled:
  file:
    - {% if enabled %}symlink{% else %}absent{% endif %}
    - name: /etc/uwsgi/apps-enabled/{{ name }}.ini
    - watch_in:
      - service: uwsgi
    {% if enabled %}
    - target: /etc/uwsgi/apps-available/{{ name }}.ini
    {% endif %}

{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
