# Languages

This is a temporary list of supported languages to better understand
how they get built on tio. This table is not intended to be maintained
but will probably live on in a form of json file somewhere in the source
repository if/when the build system is implemented.

## Sources

- copr - installed with `dnf install` from a copr repo
- ext-dnf - installed with `dnf install` from a manually added thrid party repo
- fedora - installed with `dnf install` from the fedora repo
- gist - cloned with `git clone` from gist.github
- git - cloned with `git clone` from a non github repo
- github - cloned with `git clone` from github
- linux - the `elf` binary format is the native linux binary executable format
- npm - installed with `npm install`
- pip - installed with `pip install`
- sourceforge - `cjam` is cloned from sourceforge with `hg clone`
- website - downloaded from a web site with wget/curl

## Builds

- dnf - installed with `dnf install` from a downloaded image
- fix - does not require build, but requires something else to make it work on tio. See below
- no - does not require build
- script - uses language developer provided script to build (and possibly tio-provided script, if required)

The following indicate building with this compiler or tool:

- ant
- cc
- clang
- cmake
- configure
- g++
- gcc
- javac
- make

As a rule all of these are installed with a tio-provided script of various complexity.

## Fixes

- factor - binary patch applied to redirect /dev/random to /dev/urandom, since /dev/random cannot be sandboxed
- mathics - suppress unhandled exception when statvfs is not found. statvfs is not required
- maverick - requires `npm install -g` to work properly
- seriously - uses v1 branch instead of master

## Notes

- binary in repo - compiled binary is provided in the github repo
- end of life - these langauges will never get updated which is indicated either by their location in a repository of abandoned languages (starry, thutu, underload) or because they are of an older version that presents historical interest (brachylog, fission, julia)
- has tio github repo - the language implementation was copied to a tio github repo. This typicaly means that the language is no longer maintained and does not have it's own repository. Fission2 is forked because it has not been updated for awhile and need changes to be compiled on modern stricter compilers without modification.
- license required - Dyalog APL is provided by Dyalog, through obtaining a license from them and dowmloading the language from customers download area on their website.
- no version - this is website hosted language, where the language archive does not have a version number as part of the url. In most cases these are going to be never updated. In some case the url may indicate the latest version and might be updated (such as arnoldc).
- note - various, see inline
- url version - this is website hosted language, where the language archive has the language version in the url. This means that tio setup scripts will need updating each time version bumps.

language|source|build|implementation|notes
--------|------|-----|--------------|-----
05ab1e|github|no|python|
2sable|github|no|python|
3var|github|make|c|
7|website|no|perl|no version
99|github|no|perl|has tio github repo
actually|github|no|pyhton|
a-pear-tree|website|no|perl|url version
apl-dyalog|website|no||license required, url version
apl-ngn|github|script|javascript|
arcyou|github|no|python|
arnoldc|website|no|java|no version
assembly-as|fedora|no||
assembly-gcc|fedora|no||
assembly-nasm|fedora|no||
aubergine|github|no|python|has tio github repo
awk|fedora|no||
axo|github|g++|c++|has tio github repo
bash|fedora|no||
bc|fedora|no||
beam|github|no|javascript|
bean|github|no|javascript|
beatnik|github|no|python|
beeswax|github|script|julia|has tio github repo
befunge|github|make|с|
befunge-98|github|make|с|
blc|website|cc|c|no version
brachylog|website|no|perl|end of life
brachylog2|github|no|perl|
brainbool|github|no|bash, c|
brain-flak|github|no|ruby|
brainfuck|github|no|bash, c|has tio github repo
brian-chuck|github|no|ruby|
bubblegum|github|no|python|has tio github repo
cardinal|gist|no|python|
c-clang|fedora|no||
c-gcc|fedora|no||
changeling|github|no|python|
charcoal|github|no|python|
cheddar|npm|no||
chip|github|no|python|
cinnamon-gum|github|no|python|
cjam|sourceforge|ant|java|
clisp|fedora|no||
clojure|fedora|no||
coffeescript|npm|no||
convex|github|no|java|binary in repo, no version
cow|github|gcc|c++|has tio github repo
cpp-gcc|fedora|no||
cs-mono|ext-dnf|no||
c-tcc|git|configure|c|
cubix|github|no|javascript|
cy|github|no|ruby|
d|website|dnf||url version
dash|fedora|no||
dc|fedora|no||
delimit|github|javac|java|
detour|github|no|javascript|
element|github|no|perl|
elf|linux|no||
emacs-lisp|fedora|no||
emmental|github|script|haskell|
emoji|github|no|python|
emojicode|github|script|c++|note:build changing
erlang-escript|fedora|no||
eta|website|g++|c++|no version
evil|github|javac|java|has tio github repo
factor|website|fix|c++, factor|url version
fernando|github|no|python|has tio github repo
feu|github|no|ruby|
fish|gist|no|python|
fish-shell|ext-dnf|no||
fission|github|clang|c++|has tio github repo
fission2|github|clang|c++|has tio github repo
focal|website|make|c|url version
foo|github|gcc|c|has tio github repo
forte|github|no|ruby|
forth-gforth|fedora|no||
fourier|github|no|python|
fs-mono|ext-dnf|no||
glypho|github|javac|java|has tio github repo|
go|fedora|no||
golfscript|website|no|ruby|no version
grass|website|no|ruby|no version
grime|github|script|haskell|
groovy|fedora|no||
gs2|github|no|python|
haskell|website|script||url version
haystack|github|no|python|
hbcht|pip|no||
hexagony|github|no|ruby|
i|github|gcc|c|
intercal|website|configure|c|url version
j|website|no||url version
japt|github|no|javascript|
java-openjdk|fedora|no||
java-openjdk9|copr|no||
javascript-babel-node|npm|no||
javascript-node|website|no||url version
jelly|github|no|python|
jellyfish|github|no|python|
joy|website|no|c|no version
julia|website|no||url version, |end of life
julia5|website|no||url version
k-kona|github|make|с|
k-ok|github|no|javascript|
kotlin|website|no||url version
ksh|fedora|no||
labyrinth|github|no|ruby|
lily|github|cmake|c|
logicode|github|no|python|
lolcode|github|cmake|c|
lua|fedora|no||
m|github|no|python|
malbolge|github|gcc|c|has tio github repo
mariolang|github|clang|c++|
mathics|pip|fix||
matl|github|no|octave|
maverick|github|fix|javscript|
maxima|fedora|no||
minimal-2d|github|no|python|has tio github repo
minkolang|github|no|python|
nim|website|script||url version
numberwang|github|javac|java|
oasis|github|no|python|
objective-c-clang|fedora|no||
ocaml|fedora|no||
octave|fedora|no||
parenthetic|github|no|python|
pari-gp|website|script||url version
pbrain|github|g++|cpp|has tio github repo
perl|fedora|no||
perl6|fedora|no||
php|fedora|no||
picolisp|website|make||no version
pip|github|no|python|
pl|github|no|perl|
powershell|website|script||url version
powershell-core|website|script||url version
prelude|github|no|python|has tio github repo
prolog-swi|fedora|no||
purple|github|no|python|has tio github repo
pushy|github|no|python|
pylons|github|no|python|
pyramid-scheme|github|no|ruby|
pyth|github|no|python|
python2|fedora|no||
python2-pypy|fedora|no||
python3|fedora|no||
r|fedora|no||
racket|website|script||url version
rail|website|script||url version
reticular|github|no|ruby|
retina|github|no|c#|binary in repo
rotor|github|no|groovy|
rprogn|github|no|lua|
rprogn-2|github|no|java|binary in repo
ruby|fedora|no||
rust|fedora|no||
scheme-chez|github|configure||
scheme-chicken|fedora|no||
scheme-guile|fedora|no||
sed|fedora|no||
seriously|github|fix|python|
sesos|github|no|python|
shapescript|github|no|python|
shtriped|github|no|python|
silos|github|javac|java|
slashes|github|no|perl|has tio github repo
smbf|website|gcc|c|no version
snails|github|cmake|с++|
snowman|github|make|c++|
somme|github|no|ruby|
sqlite|fedora|no||
stackcats|github|no|ruby|
stacked|github|no|javascript|
starry|github|no|ruby|end of life
straw|github|no|ruby|
taxi|github|g++|c++|has tio github repo
tcsh|fedora|no||
templates|github|no|python|
threead|github|no|lua|
thue|github|script|c|
thutu|github|no|perl|end of life
tinylisp|github|no|python|
transcript|github|no|perl|has tio github repo
trigger|website|gcc|c|no version
trumpscript|github|no|python|
turtled|github|no|python|
ubasic|github|make|c+|
underload|github|gcc|c|end of life
unlambda|website|gcc|c|url version
unreadable|github|no|python|has tio github repo
v|github|no|python|
vala|fedora|no||
visual-basic-net-mono|ext-dnf|no||
vitsy|github|no|java|binary in repo
whirl|github|g++|c++|has tio github repo
whitespace|github|make|haskell|has tio github repo
woefully|github|no|python|
yup|github|no|javascript|
zsh|fedora|no||

Source|Count
------|-----
github|113
fedora|42
website|31
ext-dnf|4
npm|3
gist|2
pip|2
sourceforge|1
git|1
linux|1
copr|1

Source|NoBuild|Count
------|-------|-----
github|True|80
fedora|True|42
github|False|33
website|False|17
website|True|14
ext-dnf|True|4
npm|True|3
gist|True|2
pip|True|2
sourceforge|False|1
git|False|1
linux|True|1
copr|True|1
