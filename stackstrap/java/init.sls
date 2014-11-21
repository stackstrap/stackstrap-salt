#
# Java SLS module
#
# Source: http://www.webupd8.org/2012/06/how-to-install-oracle-java-7-in-debian.html
#

webupd8team-java-ppa:
  pkgrepo.managed:
    - human_name: webupd8team PPA
    - name: deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/webupd8team.list
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com

jdk-install:
  pkg.installed:
    - name: oracle-java7-installer
    - debconf: salt://stackstrap/java/files/oracle-java7-installer.ans
    - require:
      - pkgrepo: webupd8team-java-ppa
