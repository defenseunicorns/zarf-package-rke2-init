#!/bin/bash

if [ -e /etc/redhat-release ]; then
  systemctl stop firewalld
  systemctl disable firewalld --now
  mkdir -p /etc/NetworkManager/conf.d/
  mv /tmp/rke2-canal.conf /etc/NetworkManager/conf.d/
  systemctl restart NetworkManager
fi