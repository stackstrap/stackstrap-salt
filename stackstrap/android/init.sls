#
# Android SDK SLS
#
# Note: Currently only configured for Vagrant
# Sources:
#   https://github.com/mafrosis/dotfiles/blob/afd452d73314318f3ff664e3f24496b577324ea9/salt/android/init.sls
#   http://stackoverflow.com/questions/4681697/is-there-a-way-to-automate-the-android-sdk-installation
#   http://stackoverflow.com/questions/13707238/install-android-old-system-images-abis-from-the-command-line
#   https://github.com/gildegoma/chef-android-sdk
#   http://stackoverflow.com/questions/19523502/androids-aapt-not-running-on-64-bit-ubuntu-13-10-no-ia32-libs-how-can-i-fix
#

include:
  - java

ant:
  pkg:
    - installed

{% if '64' in grains["cpuarch"] %}
android-abd-fix:
  pkg.installed:
    - pkgs:
      - libc6-i386
      - lib32stdc++6
      - lib32gcc1
      - lib32ncurses5
      - lib32z1
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

expect:
  pkg:
    - installed

android-sdk-update:
  cmd.script:
    - name: salt://stackstrap/android/files/update.exp
    - user: vagrant
    - require:
      - cmd: android-sdk-download
      - pkg: jdk-install
      - pkg: expect
