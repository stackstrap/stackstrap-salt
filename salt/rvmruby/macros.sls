{% macro rvmruby(domain, user, group,
                 defaults={},
                 ruby_version='1.9.3',
                 ruby_gemset=False,
                 bundle_install=True,
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

{% if ruby_gemset %}
install_gemset:
  cmd:
    - run
    - name: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm gemset create {{ ruby_gemset }} && rvm --default gemset use {{ ruby_gemset }}"
    - unless: /bin/bash -c "source ~/.rvm/scripts/rvm; rvm gemset list | grep '{{ ruby_gemset }}'"
    - user: {{ user }}
    - require:
      - cmd: install_rvm
      - cmd: install_ruby
{% endif %}

{% if bundle_install %}
bundle_install_gems:
  cmd:
    - run
    - name: "source ~/.rvm/scripts/rvm; bundle install"
    - cwd: /home/{{ user }}/domains/{{ domain }}
    - user: {{ user }}
    - onlyif: test -f /home/{{ user }}/domains/{{ domain }}/Gemfile.lock
{% endif %}

{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
