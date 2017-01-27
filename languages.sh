#!/bin/bash 

ñd /opt
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
run-parts $DIR/languages
