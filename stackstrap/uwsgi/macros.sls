#
# uWSGI macros
# 
# Copyright 2014 Evan Borgstrom
#

{% from "stackstrap/supervisor/macros.sls" import supervise %}

{% macro uwsgiapp(name, user, group, base, home, dir, socket, file, env, procs=1, enabled=True) %}

{{ base }}/uwsgi:
  file:
    - directory
    - user: {{ user }}
    - group: {{ group }}
    - mode: 750

uwsgi_{{ name }}_dirs:
  file:
    - directory
    - require:
      - file: {{ base }}/uwsgi
    - user: {{ user }}
    - group: {{ group }}
    - mode: 750
    - names:
      - {{ base }}/uwsgi/conf
      - {{ base }}/uwsgi/run
      - {{ base }}/uwsgi/log

uwsgiapp_{{ name }}:
  file:
    - managed
    - name: {{ base }}/uwsgi/conf/{{ name }}.ini
    - source: salt://stackstrap/uwsgi/files/template.ini
    - template: jinja
    - user: {{ user }}
    - group: {{ group }}
    - mode: 550
    - require:
      - pip: uwsgi
    - watch_in:
      - service: supervise_{{ name }}_uwsgi_reload
    - defaults:
        name: {{ name }}
        base: {{ base }}
        home: {{ home }}
        user: {{ user }}
        group: {{ group }}
        dir: {{ dir }}
        socket: {{ socket }}
        file: {{ file }}
        env: {{ env }}
        procs: {{ procs }}

{{ supervise(name, base, user, group, {
  'uwsgi': {
    'command': 'uwsgi --ini %s/uwsgi/conf/%s.ini' % (base, name),
    'user': user,
    'redirect_stderr': 'true',
    'stdout_logfile': '%s/uwsgi/log/uwsgi.log' % base,
    'stopsignal': 'INT'
  }
}) }}

{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
