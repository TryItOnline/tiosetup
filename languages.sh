#!/bin/bash 

./langdeps.sh
mkdir-p /var/log/tioupd
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd /opt
run-parts $DIR/languages
