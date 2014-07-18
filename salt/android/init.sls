#
# Android SDK SLS
#
# Note: Currently only configured for Vagrant
# Sources:
#   https://github.com/mafrosis/dotfiles/blob/afd452d73314318f3ff664e3f24496b577324ea9/salt/android/init.sls
#   http://stackoverflow.com/questions/4681697/is-there-a-way-to-automate-the-android-sdk-installation
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
    - source_hash: sha1=2f6d4cc7379f80fbdc45d1515c8c47890a40a781
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
    - name: ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | /home/vagrant/android-sdk-linux/tools/android update sdk -s --no-ui --filter tool,platform-tool,android-19
    - user: vagrant
    - require:
      - cmd: android-sdk-download
      - pkg: jdk-install

