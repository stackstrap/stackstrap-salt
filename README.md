# StackStrap Salt Formula

### Example minion config:

```
file_client: local

fileserver_backend:
  - git
  - roots

gitfs_remotes:
  - https://github.com/stackstrap/stackstrap-salt.git:

file_roots:
  base:
    - /vagrant/salt/root

pillar_roots:
  base:
    - /vagrant/salt/pillar
```
