{% macro rvmruby(domain, user, group,
                 defaults={},
                 custom=None) -%}

install_rvm:
  cmd:
    - run
    - name: \curl -sSL https://get.rvm.io | bash -s stable
    - unless: type rvm | head -n 1
    - user: {{ user }}
    - require:
      - pkg: rvm_deps
