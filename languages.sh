#!/bin/bash 

./langdeps.sh
cd /opt
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
run-parts $DIR/languages
