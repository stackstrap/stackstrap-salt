#
# PHP5 FPM SLS module
# 
# Copyright 2014 Evan Borgstrom
#

include:
  - stackstrap.php5

php5-fpm:
  pkg:
    - installed

  service:
    - running
    - enable: True
    - require:
      - pkg: php5-fpm
    - watch:
      - pkg: php5-packages

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
