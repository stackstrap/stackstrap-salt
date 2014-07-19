#
# Android SDK SLS
#
# Note: Currently only configured for Vagrant
# Sources:
#   https://github.com/mafrosis/dotfiles/blob/afd452d73314318f3ff664e3f24496b577324ea9/salt/android/init.sls
#   http://stackoverflow.com/questions/4681697/is-there-a-way-to-automate-the-android-sdk-installation
#   http://stackoverflow.com/questions/13707238/install-android-old-system-images-abis-from-the-command-line
#

include:
  - java

ant:
  pkg:
    - installed

{% if '64' in grains["cpuarch"] %}
ia32-libs:
  pkg:
    - installed
{% endif %}

android-sdk-download:
  file.managed:
    - name: /home/vagrant/android-sdk_r23.0.2-linux.tgz
    - source: https://dl.google.com/android/android-sdk_r23.0.2-linux.tgz
    - source_hash: md5=94a8c62086a7398cc0e73e1c8e65f71e
    - user: vagrant
    - group: vagrant
  cmd.wait:
    - name: tar xzf /home/vagrant/android-sdk_r23.0.2-linux.tgz
    - user: vagrant
    - watch:
      - file: android-sdk-download

android-sdk-chown:
  cmd.run:
    - name: chown -R vagrant:vagrant /home/vagrant/android-sdk-linux
    - require:
      - cmd: android-sdk-download

android-sdk-update:
  cmd.run:
    - name: /home/vagrant/android-sdk-linux/tools/android update sdk --all --no-ui --force --filter platform-tools,android-19,sysimg-19,build-tools-19.1.0
    - user: vagrant
    - require:
      - cmd: android-sdk-download
      - pkg: jdk-install

