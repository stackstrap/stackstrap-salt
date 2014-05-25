#
# Node.js & NVM macros
#

{% macro nvmnode(domain, user, group,
                 defaults={},
                 node_packages=None,
                 node_version='0.10.26',
                 custom=None) -%}

install_nvm:
  cmd:
    - run
    - name: curl https://raw.github.com/creationix/nvm/master/install.sh | sh
    - unless: test -d /home/{{ user }}/.nvm
    - user: {{ user }}
    - require:
      - pkg: nvm_deps

install_node:
  cmd:
    - run
    - name: /bin/bash -c "source ~/.nvm/nvm.sh; nvm install {{ node_version }} && nvm alias default {{ node_version }} && nvm use {{ node_version }}"
    - onlyif: /bin/bash -c "source ~/.nvm/nvm.sh; nvm ls {{ node_version }} | grep 'N/A'"
    - user: {{ user }}
    - require:
      - cmd: install_nvm

install_package_json:
  cmd:
    - run
    - name: "source ~/.nvm/nvm.sh; npm install"
    - cwd: /home/{{ user }}/domains/{{ domain }}
    - user: {{ user }}
    - onlyif: test -f /home/{{ user }}/domains/{{ domain }}/package.json

{% if node_packages is iterable %}{% for pkg in node_packages %}
node_package_{{ pkg }}:
  cmd:
    - run
    - names:
      - /bin/bash -c "source ~/.nvm/nvm.sh; npm install {{ pkg }}"
    - unless: /bin/bash -c "source ~/.nvm/nvm.sh; npm list {{ pkg }}"
    - cwd: /home/{{ user }}/domains/{{ domain }}
    - user: {{ user }}
    - require:
      - cmd: install_node
{% endfor %}{% endif %}

{% endmacro %}

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
