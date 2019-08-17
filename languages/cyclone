#!/bin/bash

err=0
trap 'err=1' ERR

rm -rf cyclone
mkdir cyclone
cd cyclone
curl -sSL https://raw.githubusercontent.com/stasoid/Cyclone/master/cyclone.tar.xz \
	| tar x --xz

exit "$err"
