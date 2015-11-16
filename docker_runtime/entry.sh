#!/bin/bash

set -x -e -u

# Regerate SSH Host Keys
/bin/rm -vf /etc/ssh/ssh_host_*
/usr/sbin/dpkg-reconfigure openssh-server

mkdir -p /root/.ssh
if [[ ${GITHUB_USERS_TO_ALLOW_SSH:-unset} != unset ]]; then
  for ghuser in $GITHUB_USERS_TO_ALLOW_SSH; do
    curl -fsSL https://github.com/${ghuser}.keys >> /root/.ssh/authorized_keys
  done
fi

exec /usr/sbin/sshd -D
