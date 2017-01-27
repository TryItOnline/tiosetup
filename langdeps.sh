#!/bin/bash

dnf install perl-CPAN npm java-1.?.0-openjdk nasm gcc-c++ clang julia glibc-devel.i686 libgcc.i686 pl ruby texi2html texinfo redhat-rpm-config python3-devel pcre-devel mercurial ant clisp clojure mono-devel dash -y
npm install -g cheddar-lang coffee-script
python3 -m pip install python-pcre
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Digest::CRC'
wget http://downloads.dlang.org/releases/2.x/2.073.0/dmd-2.073.0-0.fedora.x86_64.rpm
dnf install dmd-2.073.0-0.fedora.x86_64.rpm -y
rm -f dmd-2.073.0-0.fedora.x86_64.rpm
