#
# Ruby & RVM SLS
#

rvm_deps:
  pkg:
    - installed
    - names:
      - bash
      - coreutils
      - gzip
      - bzip2
      - gawk
      - sed
      - curl
      - git-core

ruby_deps:
  pkg:
    - installed
    - names:
      - libreadline6-dev
      - libssl-dev
      - libyaml-dev
      - libsqlite3-dev
      - sqlite3
      - autoconf
      - libgdbm-dev
      - libncurses5-dev
      - automake
      - libtool
      - bison
      - pkg-config
      - libffi-dev
