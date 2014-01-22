

nvm_deps:
  pkg:
    - installed
    - names:
      - git
      - curl

install_nvm:
  cmd:
    - run
    - name: curl https://raw.github.com/creationix/nvm/master/install.sh | sh
    - unless: test -d /home/vagrant/.nvm
    - user: vagrant
    - require:
      - pkg: nvm_deps

install_node:
  cmd:
    - run
    - name: /bin/bash -c "source ~/.nvm/nvm.sh; nvm install {{ pillar['node_version'] }} && nvm alias default {{ pillar['node_version'] }} && nvm use {{ pillar['node_version'] }}"
    - onlyif: /bin/bash -c "source ~/.nvm/nvm.sh; nvm ls {{ pillar['node_version'] }} | grep 'N/A'"
    - user: vagrant
    - require:
      - cmd: install_nvm

install_package_json:
  cmd:
    - run
    - name: "source ~/.nvm/nvm.sh; npm install"
    - cwd: /vagrant
    - user: vagrant

{% if 'node_packages' in pillar %}{% for pkg in pillar['node_packages'] %}
node_package_{{ pkg }}:
  cmd:
    - run
    - names:
      - /bin/bash -c "source ~/.nvm/nvm.sh; npm install {{ pkg }}"
    - unless: /bin/bash -c "source ~/.nvm/nvm.sh; npm list {{ pkg }}"
    - cwd: /vagrant
    - user: vagrant
    - require:
      - cmd: install_node
{% endfor %}{% endif %}

# vim: set ft=yaml et sw=2 ts=2 sts=2 :
