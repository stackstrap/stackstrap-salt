{% macro rvmruby(domain, user, group,
                 defaults={},
                 ruby_version='1.9.3',
                 custom=None) -%}

install_rvm:
  cmd:
    - run
    - name: curl -sSL https://get.rvm.io | bash -s stable
    - unless: /bin/bash -c "source ~/.rvm/scripts/rvm; type rvm | head -n 1 | grep 'rvm is a function'"
    - user: {{ user }}
    - require:
      - pkg: rvm_deps

install_ruby:
  cmd:
    - run
    - name: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm install {{ ruby_version }} && rvm --default use {{ ruby_version }}"
    - unless: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm list rubies | grep '{{ ruby_version }}'"
    - user: {{ user }}
    - require:
      - cmd: install_rvm

{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
