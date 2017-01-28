#!/bin/bash

rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
dnf config-manager --add-repo http://download.mono-project.com/repo/centos/
dnf config-manager --add-repo http://download.opensuse.org/repositories/shells:fish:release:2/Fedora_24/shells:fish:release:2.repo
dnf install perl-CPAN npm java-1.?.0-openjdk nasm gcc-c++ clang julia glibc-devel.i686 libgcc.i686 pl ruby texi2html texinfo redhat-rpm-config python3-devel pcre-devel mercurial ant clisp clojure mono-complete fsharp haskell-platform dash erlang allegro5-devel fish gforth golang ncurses-compat-libs flex flex-devel bison bison-devel -y
npm install -g cheddar-lang coffee-script babel-cli
python3 -m pip install exrex python-pcre hbcht numpy sympy
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Digest::CRC'
gem install treetop
wget http://downloads.dlang.org/releases/2.x/2.073.0/dmd-2.073.0-0.fedora.x86_64.rpm
dnf install dmd-2.073.0-0.fedora.x86_64.rpm -y
rm -f dmd-2.073.0-0.fedora.x86_64.rpm
cabal update
cabal install parsec
