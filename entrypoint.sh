#!/bin/bash
set -e

if [[ ! -f /ssh_keys/ssh_host_rsa_key ]]; then
  echo "Generating ssh_host_rsa_key..."
  ssh-keygen -f /ssh_keys/ssh_host_rsa_key -N '' -t rsa
  chmod 0600 /ssh_keys/ssh_host_rsa_key
fi

/usr/sbin/sshd -D
