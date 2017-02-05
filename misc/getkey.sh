#!/bin/bash 

cat $(getent passwd apache | cut -d: -f6)/.ssh/id_rsa.pub
