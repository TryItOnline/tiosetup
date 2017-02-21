# Setting up Try it Online

## What is Try It Online

<https://tryitonline.net> is a community-maintained web site for hosting solutions to [code golf](https://en.wikipedia.org/wiki/Code_golf) puzzles presented on <http://codegolf.stackexchange.com/>. It can be used by anyone for free to quickly try out and share code snippets in a big number of practical and recreational programming languages.

## Setup Overview

These instructions are written to help setting up a new instance of <http://tryitonline.net>.

TIO currently runs on 4 domains which are hosted on 2 servers:

- [Main server](https://github.com/TryItOnline/main-server.git) - split across 3 domains:
  - tryitonline.net - serves the front page, provides some assets for the rest of the sites
  - tio.run - TIO Nexus and TIO v2 front end, short url for permalinks
  - backend.tryitonline.net - serves web api calls from tio.run
- [Arena server](https://github.com/TryItOnline/arena-server.git) - sandbox where the actual code is executed, running on SeLinux and accessed by the backend.tryitonline.net via SSH

The setup makes use of [SeLinux](https://en.wikipedia.org/wiki/Security-Enhanced_Linux) support of which varies between different distributions of Linux.

[talk.tryitonline.net](http://talk.tryitonline.net) domain is setup to redirect to Stack Exchange chat about the tryitonline service. Setting this domain up is not covered by this guide.

This setup runs on **Fedora 25**. It was tested on those two hosting providers:

- <http://vultr.com>
- <http://digitalocean.com>

It is assumed that you have a freshly provisioned instance on any of the above. All scripts a run as root.

## Vultr vs Digital Ocean

It turns out, there there are enough discrepancies between Vultr and Digital Ocean images for Fedora 25, that it affects our setup scripts.

Below outlined the main differences that are useful to be aware of:

Vultr|Digital Ocean|Comment
-----|-------------|-------
5$ vm has 768MB of memory|5$ vm has 512MB of memory|As of the moment of writing both main and arena will happily run on the 512MB VM. However, sometimes 512MB or even 768MB is not enough for installing certain languages. Thus a swap file is recommended. The size of the swap file can be reduced, or the swap file can be disabled, after the installation. The provided scripts create a swap file but do not disable it after installation.
5$ vm has 15GB of SSD|5$ vm has 20GB of SSD| With 1.5GB swapfile there is barely enough space on vultr for all the languages. With log files constantly growing the VM can quickly get out of disk space. Either use a VM with bigger disk, or have a solution in place to watch/free remaining disk space.
SeLinux is disabled|SeLinux is enabled|Vultr image has SeLinux disabled. In order to enable SeLinux a reboot is required. Because of this the setup scripts, if SeLinux is disabled, install runonce service that continues the setup script after reboot
Some dnf packages are installed|Minimal dnf packages are installed|Vultr seems to have more up-to-date images with `dnf update` run on them at some point in the past, things like git, nano and wget may be pre-installed. Digital Ocean contains minimal system with no `dnf update` run. If `dnf upfate` is not run on Digital Ocean before running `dnf install` certain package installation may fail. Setup scripts account for this difference.
No downsizing VM|Can downsize VM|Digital Ocean allows upsizing and downsizing images as long as SSD allocation is not changed. Thus, with Digital Ocean it's advisable to upsize the VM (to the 20$ size) before running the setup scripts and downsize when finished. This will virtually guarantees, that setup won't run out of memory. We've seen during our testing an occasional killing of a process by OOM killer, which prevents setup from succeeding (even with the swap file). It never happened if an instance was upsize first. Vultr installation was not noticed to go out of memory with 768MB VM and 1.5GB of swap. `dnf install` commands were split to several batches because it uses less memory and allows the setup scripts to finish.
Supports startup scripts|No startup scripts|Vultr allows you to specify a script which is run on the first boot of freshly provisioned VM. This script is also run on the first boot when rebuilding an existing VM. This is convenient when tweaking the setup scripts. Digital Ocean does not provide this facility.

## Domain registration and certificates

In order to setup TIO, you will need the following sub-domains created within your domains. Note that these are the ones that TIO itself uses, yours, obviously will be different:

- tryitonline.net
- tio.run
- backend.tryitonline.net
- arena.tryitonline.net

You will need to provide yor domain names to the setup scripts.

Our setup scripts use [LetsEncrypt](https://letsencrypt.org/) for SSL certificates, which is free service. You are welcome to use your own certificates, but you will need to update the setup scripts accordingly.
LetsEncrypt uses [Certbot](https://certbot.eff.org/) for generating SSL certificates and configuring apache to use them. In order for this to work, the domains that you are going to be using in your setup has to point to the the VM IP address that you are running the setup scripts on.
Thus, a recommended sequence would be following:

- Register one or more domains to use with TIO
- Provision a TIO Main Server machine
- Point the three domains (your versions of tryitonline.net, tio.run and backend.tryitonline.net) to the VM IP

After that Certbot will be able to validate the fact that it's you who are controlling these domains, and generate the certificates for you.
Note, that LetsEncrypt limits you to 5 sets of certificates per week for each domain combination you use. Thus, if you are going to run the setup scripts multiple times (for testing), it is advisable to `tar czf letsencrypt.tar.gz /etc/letsencrypt` after the first tun of the setup scripts, so that you can reuse these certificates on the next run, and thus avoid hitting the rate limit.


## Generating ssh key

Backend communicates with arena via ssh. Because of this there should be a private ssh key on the Main server and corresponding public key on the arena server.
use `ssh-keygen` command on Linux to generate `id_rsa` private key and `id_rsa.pub` public key. You will need to provide these to the setup scripts.

## Dyalog APL

TIO has a license to run [Dyalog APL](http://dyalog.com/). Note, that if you do not have a license, and thus Dyalog install archive, the rest of the setup scripts will work fine, and only the Dyalog APL script will show a error which can safely be ignored. It does not affect the rest of languages on TIO. If you do have [a license](http://dyalog.com/prices-and-licences.htm), then you'll need to provide the Linux x64 install archive to the setup scripts.

## Setup scripts structure

Top level folders:

- `arena` - scripts used for setting up arena server
- `common` - scripts symlinked from both arena and main folders
- `main` - script used for setting up main server
- `misc` - miscellaneous scripts *not* used by the setup scripts. Mainly convenience for maintainers

- `arena/files`, `main/files` - those are various files used by setup scripts during setup process.
- `arena/languages` - scripts for installing individual languages. Note that not all language are installed with these scripts. Some languages come from dnf, pip, npm or other sources.
- `arena/logsamples` - these are not used by setup scripts, and just a samples of what installation logs should look like. These are not maintained, so yours may look slightly differently.
- `arena/private`, `main/private` - these are files that contain information that may vary from installation to installation. See below.
- `arena/stage1`, `main/stage1` - scripts executed before reboot (if reboot required)
- `arena/stage2`, `main/stage2`- scripts executed after reboot (if reboot required)

In order to enable SeLinux a reboot must be performed. In this case everything before reboot is executed in Stage 1, and everything else is executed in Stage 2. If reboot is not required both Stage 1 and Stage 2 is executed without reboot. `runeonce` service from `common` folder is installed to continue after reboot in case reboot is required.

- `arena/bootstrap`, `main/bootstrap` - this is the script that needs to be run to start the setup process
- `arena/run-scripts`, `main/run-scripts` - a utility script that executes all scripts for a specified directory, such as `stage1`, `stage2` or `arena\languages`.
- `arena/setup-main`, `main/setup-main` - script that continues after reboot, if reboot is required

## Setting up arena

Once you cloned the repository you will need to make changes to files in the `arena\private` directory. Here is `setup.conf`:

```Bash
# This number should be divisible by 1024. This is the size of the swap file.
# On 512MB of RAM, a size smaller than 1572864 may lead to some languages failing to compile
SwapfileSize="1572864"
#Sets MaxRetentionSec in journald.conf
JOURNALRETENTION="1week"
# In order for the scripts to work, you need to download 64-bit Dyalog APL to /opt.
# You need a valid Dyalog license for that.
# The install script depends on the Dyalog APL archive name, which has a version,
# thus, for a different version of the archive to work you will need to modify
# languages/apl-dyalog script. If you do not have the license you
# can run the setup script without the Dyalog APL archive, but Dyalog APL won't be installed.
# In order to acknowledge that you configured all required information in
# the private folder, set the following line to
# ConfigChanged="y"
ConfigChanged="n"
```

Setup scripts tested to be worked on Vultr and Digital Ocean with 786 and 512 MB of memory respectively with the swap file of 1.5GB. They also work with 2GB of memory without swap file.
if you comment out `SwapfileSize` setting, no swap file will be created.
More information about `journald` configuration can be found [here](https://www.freedesktop.org/software/systemd/man/journald.conf.html). Look for `MaxRetentionSec` setting.
Change to `ConfigChanged="y"` to acknowledge that you edited all files in `private` to your satisfaction. Setup scripts will run all `+x` scripts in `private`, 
so review `private/010-custom` and add more scripts if needed.

Below is a general scenario of starting arena setup:

```Bash
cd /root
dnf install wget git nano screen -y

#put linux_64_15.0.29007_unicode.zip to /opt (make sure that the version matches the one mentioned in `arena/langauges/apl-dyalog`)

git clone https://github.com/TryItOnline/TioSetup.git
cd TioSetup/arena

# put your public key you generated earlier for connection to arena in private/id_rsa.pub

# edit private/setup.conf

# edit /private/010-custom script if required, or add more scripts to /private to execute at the end of setup process

./bootstrap
```

Note that teh script can reboot the box if needed. Logs can be found in various places:

- `/var/log/runonce` directory - continuation after reboot logs
- `/var/log/tioupd` directory - logs from individual scripts from `stage1`, `stage2`, and `arena\languages` folders. You can `tail` individual items from here for long-running sub-scripts.
- `journalctl -t run-scripts` or `tiolog` for overall installation progress. You can tail these commands with `-f`.


## Setting up main server

Most of the points from previous sections also apply here.

Update `private/setup.conf` as per below.

```Bash
# The following four settings are for the domain names used in the setup
# Please read more about them in accompanying documentation.
# Domain where https://tryitonline.net will be hosted
TRYITONLINENET=www2.tryitonline.nz
# Domain where https://tio.run will be hosted
TIORUN=tio2.tryitonline.nz
# Domain where https://backend.tryitonline.net will be hosted
BACKEND=backend2.tryitonline.nz
# Domain where arena.tryitonline.net will be hosted
ARENA=arena2.tryitonline.nz
# This is your email used for LetsEncrypt certificate revocations
EMAIL=letsencrypt@tryitonline.nz
#Sets MaxRetentionSec in journald.conf
JOURNALRETENTION="1week"
# put your backed up let's encrypt certificates from previous TIO installation in
# private/letsencrypt.tar.gz and leave this setting alone
# Alternatively if you do not have the certs yet and would like to generate them
# change the line to
# UseSavedCerts="n"
# Note that LetsEncrypt limits you to 5 cert requests per week so you do not want
# to keep this setting saying n if your first attempt to install the mirror failed
# see accompanying documentation to find out how to back up generated letsencrypt
# certificates in this case
UseSavedCerts="y"
# In order for the install to succeed you need to provide a public and private ssh key
# that will be used for establishing ssh connection between backend and arena. See
# accompanying documentation to find out how to generate them.
# Put the private key to private/id_rsa
# Put the public key to public/id_rsa.pub
# letsencrypt.tar.gz
# In order to acknowledge that you configured all the required information below in
# the private folder set the following line to
# ConfigChanged="y"
ConfigChanged="n"
```

```Bash
cd /root
dnf install git nano screen openssl wget -y
git clone https://github.com/TryItOnline/TioSetup.git
cd TioSetup/main

# put your previously saved letsencrypt.tar.gz to private/letsencrypt.tar.gz
# or make sure to edit private/setup.conf to read `UseSavedCerts="n"`

# edit private/setup.conf

# edit /private/010-custom script if required, or add more scripts to /private to execute at the end of setup process

# put your public key you generated earlier for connection to arena in private/id_rsa.pub

# put your private key you generated earlier for connection to arena in private/id_rsa

./bootstrap
```

Monitor execution same as described in previous section.

Setup scripts for the main server use [`ssh-keyscan`](http://man.openbsd.org/ssh-keyscan) to add arena into the list of know_hosts so that SSH connection is possible. This implies that arena server is already up and running, so it is recommended to run this script *after* arena has been setup.

Digital Ocean and Vultr offer the private IP feature, where all the traffic in the private network is unmetered. You might want to use this feature. If you do, modify your host file on the main server so that your arena DNS resolves to the private IP of your arena.

