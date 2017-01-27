#!/bin/bash

semanage fcontext -a -t bin_t '/srv/bin(/.*)?'
semanage fcontext -a -t bin_t '/srv/wrappers(/.*)?'
restorecon -Rv /home/runner/.ssh/authorized_keys
restorecon -Rv /srv/bin
restorecon -Rv /srv/wrappers
