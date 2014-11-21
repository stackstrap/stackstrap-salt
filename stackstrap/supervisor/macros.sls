#
# Supervisor Macros
# 
# Copyright 2014 Evan Borgstrom
#

#
# Setup a supervisord process for the specified programs
# 
# name: A name for this supervisor process group
# home: The home directory, where to store config & run info
# user: The user to run as
# group: The group to run as
# programs: An dict of dicts. Each dict is iterated over and the keys & values
#           are used to make up the [program:id] block in the supervisord.conf
#           file
#
# Example:
# supervise("my_web_app", "/home/my_web_app", "user", "group", {
#   'uwsgi': {
#     'program': '...'
#   },
#   'celery': {
#     'program': '...'
#   }
# }
#
{% macro supervise(name, home, user, group, programs) -%}

{{ home }}/supervisor:
  file:
    - directory
    - user: {{ user }}
    - group: {{ group }}
    - mode: 750

supervise_{{ name }}_dirs:
  file:
    - directory
    - require:
      - file: {{ home }}/supervisor
    - user: {{ user }}
    - group: {{ group }}
    - mode: 750
    - names:
      - {{ home }}/supervisor/conf
      - {{ home }}/supervisor/run
      - {{ home }}/supervisor/log

{{ home }}/supervisor/conf/{{ name }}.conf:
  file:
    - managed
    - user: {{ user }}
    - group: {{ group }}
    - source: salt://stackstrap/supervisor/files/template.conf
    - template: jinja
    - require:
      - file: supervise_{{ name }}_dirs
    - watch_in:
      - cmd: supervise_{{ name }}_reload
    - defaults:
        name: {{ name }}
        home: {{ home }}
        user: {{ user }}
        group: {{ group }}
        programs:
{% for program in programs %}
          {{ program }}:
{% for key in programs[program] %}
            {{ key }}: {{ programs[program][key] }}
{%- endfor %}
{%- endfor %}

supervise_{{ name }}_run:
  cmd:
    - run
    - name: supervisord -c {{ home }}/supervisor/conf/{{ name }}.conf
    - unless: '/bin/ps -p `cat {{ home }}/supervisor/run/supervisord.pid` >/dev/null'
    - require:
      - file: {{ home }}/supervisor/conf/{{ name }}.conf

supervise_{{ name }}_reload:
  cmd:
    - wait
    - name: 'kill -HUP `cat {{ home }}/supervisor/run/supervisord.pid` >/dev/null'
    - onlyif: '/bin/ps -p `cat {{ home }}/supervisor/run/supervisord.pid` >/dev/null'

# create cmd.wait targets for each of our programs so things can trigger their reload
{% for program in programs %}
supervise_{{ name }}_{{ program }}_reload:
  cmd:
    - wait
    - name: 'supervisorctl -c {{ home }}/supervisor/conf/{{ name }}.conf restart {{ program }}'
    - onlyif: '/bin/ps -p `cat {{ home }}/supervisor/run/supervisord.pid` >/dev/null'
{% endfor %}

{%- endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
