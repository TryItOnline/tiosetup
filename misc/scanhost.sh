#!/bin/bash 

rm -f $(getent passwd apache | cut -d: -f6)/.ssh/known_hosts
sudo -u apache ssh-keyscan arena.tryitonline.nz > $(getent passwd apache | cut -d: -f6)/.ssh/known_hosts
sudo -u apache ssh-keyscan $(dig +short arena.tryitonline.nz) >> $(getent passwd apache | cut -d: -f6)/.ssh/known_hosts
