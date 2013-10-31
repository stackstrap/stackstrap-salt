#
# StackStrap top.sls
#

base:
  'stackstrap-master*':
    - stackstrap.master

  '^user-(\d+)-project-(\d)$':
    - match: pcre
    - stackstrap.auto.dev

# vim: set ft=yaml ts=2 sw=2 et sts=2 :
