#!/bin/bash

set -x -e -u

# Regerate SSH Host Keys
/bin/rm -vf /etc/ssh/ssh_host_*
/usr/sbin/dpkg-reconfigure openssh-server

for ghuser in $GITHUB_USERS_TO_ALLOW_SSH; do
  curl -fsSL https://github.com/${user}.keys >> /root/.ssh/authorized_keys
done

exec /usr/sbin/sshd
