#
# PHP5 SLS module
#
# Installs the CLI interface and common modules
# 
# Copyright 2014 Evan Borgstrom
#

php5-packages:
  pkg:
    - installed
    - names:
      - php5-mysql
      - php5-gd
      - php5-curl
      - php5-cli
      - php5-intl

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
