# Setting up Try it Online

## Overview

*** !!! Work in progress - do not use !!! ***

These instructions are written to help setting up a new instance of <http://tryitonline.net>
Since TryItOnline can run on a variaty of linux systems, it is not possible to test
these on all of them. These instructions were tested on Fedora 24
and are aimed to simplify most labourious parts of the setup process, however some commands,
path, etc, might need changing on other linux systems, use your judgement.

The setup consists of the 4 domains:

- tryitonline.net (Old url, front page, provides some assets for the rest of the site)
- tio.run (Tio Nexus and Tio v2 front end)
- backend.tryitonline.net (serves web api calls from tio.run)
- arena.tryitonline.net (that's where the actual code is executed, accessed by the backend via SSH)

Sources for each of these are located in the corresponding github repositiry named after respective domain.

The domain names in the list above are hardcoded in the source code. Before you start, you need
to decide what domain names are you going to be using for each of the four of them. When this guide
talks about "your tryitonline.net" domain name or your "tio.run" domain name, these are
what you should be using.

We are going to use two server setup. One server will host tryitonline.net, tio.run, backend.tryitonline.net
and the other will host arena.tryitonline.net.

All commands below unless specified, are run as root

## Setting up tryitonline.net, tio.run and backend.tryitonline.net

Run the following commands.

Make sure you have apache and git:

```Shell
dnf install httpd mod_ssl git -y
```

Clone the three web sites.

```Shell
cd /var/www
git clone https://github.com/TryItOnline/tryitonline.net.git
git clone https://github.com/TryItOnline/tio.run.git
git clone https://github.com/TryItOnline/backend.tryitonline.net.git
```

You might want to delete .git, README.md, etc if you want, or put specific permissions
so they do not get served by httpd.

To substitute the domain names in the code base, edit the following script to include your domain
instead of "your.domain" and run it.

```Shell
cd tryitonline.net
sed -i 's/tryitonline.net/tryitonline.your.domain/g' manifest.json
sed -i 's/tio.run/tio.your.domain/g' manifest-nexus.json
sed -i 's/tryitonline.net/tryitonline.your.domain/g' index.html
sed -i 's/tio.run/tio.your.domain/g' index.html
cd ..
cd tio.run
sed -i 's/backend.tryitonline.net/backend.tryitonline.your.domain/g' index.html
sed -i 's/tio.run/tio.your.domain/g' index.html
sed -i 's/server-costs@tryitonline.net/this-is-a-site-copy/g' index.html
sed -i 's/feedback@tryitonline.net/this-is-a-site-copy/g' index.html
sed -i 's/tryitonline.net/tryitonline.your.domain/g' index.html
sed -i 's/talk.tryitonline.your.domain/talk.tryitonline.net/g' index.html
sed -i 's/backend.tryitonline.net/backend.tryitonline.your.domain/g' nexus.html
sed -i 's/tio.run/tio.your.domain/g' nexus.html
sed -i 's/server-costs@tryitonline.net/this-is-a-site-copy/g' nexus.html
sed -i 's/feedback@tryitonline.net/this-is-a-site-copy/g' nexus.html
sed -i 's/tryitonline.net/tryitonline.your.domain/g' nexus.html
sed -i 's/talk.tryitonline.your.domain/talk.tryitonline.net/g' nexus.html
cd ..
cd backend.tryitonline.net
sed -i 's/tryitonline.net/tryitonline.your.domain/g' run
sed -i 's/tryitonline.net/tryitonline.your.domain/g' run-legacy
cd ..
```

Note that commands above modify feedback and donation emails so that they do not lead to your domain. You might want to do more text editing for your copy of the site.

Create apache Virtual Host for each of the three sites:

```Shell
cat <<EOT >> /etc/httpd/conf.d/tio.conf
<VirtualHost *:80>
    <Directory /var/www/tio.run/>
        Options FollowSymLinks
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
    ServerName tio.your.domain
    DocumentRoot /var/www/tio.run
    ErrorLog /var/log/tio.run.error.log
    CustomLog /var/log/tio.run.access.log combined
</VirtualHost>
EOT
cat <<EOT >> /etc/httpd/conf.d/tryitonline.net.conf
<VirtualHost *:80>
    Header set Access-Control-Allow-Origin "*"
    <Directory /var/www/tryitonline.net/>
        Options FollowSymLinks
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
    ServerName tryitonline.your.domain
    DocumentRoot /var/www/tryitonline.net
    ErrorLog /var/log/tryitonline.net.error.log
    CustomLog /var/log/tryitonline.net.access.log combined
</VirtualHost>
EOT
cat <<EOT >> /etc/httpd/conf.d/backend.tryitonline.net.conf
<VirtualHost *:80>
    ScriptAlias "/" "/var/www/backend.tryitonline.net/"
    <Directory /var/www/backend.tryitonline.net/>
        Options FollowSymLinks
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
    ServerName backend.tryitonline.your.domain
    DocumentRoot /var/www/backend.tryitonline.net
    ErrorLog /var/log/backend.tryitonline.error.log
    CustomLog /var/log/backend.tryitonline.access.log combined
</VirtualHost>
EOT
```

Create htaccess so that /nexus is rewritten to /nexus.html

```Shell
cat <<EOT >> /var/www/tio.run/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^([^.]+?)/?$ /$1.html [L,R=302]
EOT
```

Configure default host out of the way:

```Shell
sed -i 's/SSLEngine on/SSLEngine off/g' /etc/httpd/conf.d/ssl.conf
sed -i 's/#ServerName www.example.com:80/ServerName 127.0.0.1:80/g' /etc/httpd/conf/httpd.conf

```

Create a store for the user code snippets.

```Shell
mkdir /srv/store
setfacl -m user:apache:rwx /srv/store
```

Enable http and https on the firewall and recycle apache:

```Shell
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload
systemctl restart httpd
```

After this is done you need:

- Install SSL certificate for your web site
- Configure your web site to only accept https and redirect all http to https

It can be done relatively easy with letsencrypt and certbot:

```Shell
dnf install python-certbot-apache -y
certbot --apache
```

And then follow the propmts. Choose "Secure" option when asked if to enforce HTTPS. Certbot will advise you to backup your keys and certifcates, it would be advisable to do so. 
For systems other than apache on Fedora 23+ refer to:

- <https://letsencrypt.org>
- <https://certbot.eff.org>

Certbot checks that the domain name you are getting the cert for resolve to the address of your server, so if you have not sorted this out yet in needs to be done first.
Letsecrypt certificates are good for three months. Here is how you can set up automatic renewal on Fedora 24:

```Shell
cat <<EOT >> /etc/systemd/system/renewssl.service
[Unit]
Description=Renews letencrypt SSL certificates

[Service]
Type=simple
ExecStart=/bin/sh -c 'letsencrypt renew'
EOT

cat <<EOT >> /etc/systemd/system/renewssl.timer
[Unit]
Description=Run renewssl.service twice a day

[Timer]
OnCalendar=04:14
OnCalendar=16:14

[Install]
WantedBy=timers.target
EOT

systemctl start renewssl.timer
systemctl enable renewssl.timer
systemctl list-timers -all
```

Change hours and minutes above to what suits you most. Letsencrypt advises not to use round minutes value such as 00 or 30, to spread there service load, after all you are not paying them.
You also might want to run the following to set your time zone if you have not already (change the below to your timezome):

```Shell
timedatectl set-timezone Pacific/Auckland
```

Of course you do not have to use letsecrypt and if you wish you can install your SSL certificates the usual way.

Navigate to your tryitonline.net domain, you should see the home page.
Check that links to TIO Nexus and TIO.run lead to your tio.run domain.
Open your browser console and make sure that there are no errors displayed there.
Navigate to your tio.run domain, you should see the "Welcome to Try It Online version 2!" home page.
Try the nexus and the v2 links, also go back to your tryitonline.net domain (you can do it by clicking
on the logo in the top left corner) and go to the Nexus and the v2 links from there. Watch the browser
console for errors. At this stage all the UI should be fully working,
only the "run" functionality is not setup yet.
Generating and resoving permalinks should be fully working now.

## Setting up arena.tryitonline.net

On your web server (above) generate ssh key for access to arena:

```Shell
mkdir -p $(getent passwd apache | cut -d: -f6)/.ssh
chown apache:apache $(getent passwd apache | cut -d: -f6)/.ssh
sudo -u apache ssh-keygen -t rsa -f $(getent passwd apache | cut -d: -f6)/.ssh/id_rsa -N ""
```

On your arena.tryitonline.net server install required packages and enable selinux:

```Shell
dnf install git psmisc selinux-policy-sandbox policycoreutils-sandbox vim-common setroubleshoot -y
sed -i 's/SELINUX=disabled/SELINUX=enforcing/g' /etc/selinux/config
reboot
```

When system is labeled by selinux and is back online, configure the runner user:

```Shell
adduser runner
sudo -u runner -i
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
chmod 640 ~/.ssh/<authorized_keys></authorized_keys>
chmod 700 ~/.ssh
```

Now append the ssh key that you generateed on the backend server (the whole id_rsa.pub file) to the \~/.ssh/authorized_keys
for the runner user. Exit the runner user context. Label the arena executables:

```Shell
semanage fcontext -a -t bin_t  '/srv/bin(/.*)?'
semanage fcontext -a -t bin_t '/srv/wrappers(/.*)?'
````

Clone arena repository and restore security context:

```Shell
git clone https://github.com/TryItOnline/arena.tryitonline.net.git /srv
restorecon -Rv /srv/bin
restorecon -Rv /srv/wrappers
```

Update the languages.

(TODO: instructions/scripts for the rest of languages are to be provided)
Here is the example for 05AB1E:

```Shell
cd /opt
git clone https://github.com/Adriandmen/05AB1E.git
```

Now back on the web server test ssh connection:

```Shell
sudo -u apache ssh runner@arena.tryitonline.your.domain
```

Confirm that you want to continue connecting, when asked, and make sure that you are connected without being asked for a password.

Now you are up and running. Go to both nexus and your tio.run and run a test program. For 05AB1E it can be `5L`, which should output an array from 1 to 5.
