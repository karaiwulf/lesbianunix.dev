+++
title = "Website CI Pipeline"
date = "2021-02-19T03:47:52-07:00"
author = "Kararou Ren"
authorTwitter = "karaiwulf" #do not include @
cover = ""
tags = ["UNIX", "SmartOS", "CI"]
keywords = ["website", "ci"]
description = "A short description of the continuous integration pipeline used for my websites."
showFullContent = false
+++

I just want my websites to update without my intervention, so what do I do?
Obviously, I make a set of easily deployed tools that rely upon an
infrastructure that's been setup previously (maybe one day I'll make a post
about my gitea server and how I set it up to update automagically).

## Installing Dependencies

So what did I do, anyway?  Well, for starters, I've got a
[SmartOS](https://wiki.smartos.org) hypervisor running, which then has a
base-64 zone [setup](https://wiki.smartos.org/how-to-create-a-zone/).  Once a
zone has been setup, there are a few packages that are required.

    pkgin in nginx

If you need to build hugo as well, you'll need to also install
`build-essential` and `go`.

    pkgin in nginx build-essential go

## Building Hugo

Alright, we're getting there.  We've got a lot of tools, but have basically
done nothing (yet).  We still have to build some software (this can be done in
a separate zone).

    mkdir ~/src && cd ~/src
    git clone https://github.com/gohugoio/hugo.git
    cd hugo
    CGO_ENABLED=1 go install --tags extended
    cp ~/go/bin/hugo /opt/local/bin/hugo

Its as simple as that.  Hugo will take a few minutes to build.  I went for a
coffee while it built.

## Cloning Website and Testing Hugo

In proper fashion, we aught to actually test our tools.  I went ahead and
cloned my website's source code to `/opt`.  Make sure to also pull any
submodules in:

    cd /opt && git clone https://git.kararou.space/karaiwulf/www-fakewebsite.git
    cd www-fakewebsite
    git submodule update --init --recursive
    hugo

At this point, hugo should have built your website and it should be available
in the `/opt/www-fakewebsite/public` directory.  Modify the nginx config
(located at `/opt/local/etc/nginx/nginx.conf`) to point to this directory, then
enable it `svcadm enable nginx`.

If all has gone well, you'll be able to see your website when you navigate to
the server's IP address or domain name.

## Automated Update Script

Okay, so we've built ourselves yet another tool then placed it in
`/opt/local/bin`.  Awesome.  Now how to we make it automatically build?  I
built a script!

```bash
#!/usr/bin/bash
#/opt/local/bin/auto-update.sh
#TODO: Make me executable using 
#chmod +x /opt/local/bin/auto-update.sh

while true
do
        cd /opt/www-fakewebsite
        /opt/local/bin/git pull
        /opt/local/bin/git submodule update --init --recursive
        /opt/local/bin/hugo
        sleep 600
done
```

Okay, but this is just a script, how does it run?  Well, you could set it on a
cronjob, but that'd be a bit silly, since we don't want multiple instances of
this script running.  So I used [smfgen](https://github.com/joyent/smfgen) to
make a service manifest for it.

    npm install -g smfgen
    smfgen -i site-update -l 'Example Site Auto-Update Service' \
      -s '/opt/local/bin/auto-update.sh' -d /opt/www-fakewebsite \
      -eHOME=/root > ~/update.xml
      
We used `-eHOME=/root` because we were using the git credential helper to store
our credentials.

## TL;DR

Alright fine, here's a script, have fun:

```bash
# Configuration Parameter
GITREPO=https://change.me/now/because_i_dont_work.git

echo "This will setup a hugo website on a SmartOS machine."
echo "GITREPO is set to $GITREPO"
echo "If that isn't correct, please CTRL+C NOW\!"

# Installing Depends
echo "Installing depends..."
pkgin in go build-essential nginx

# Build Hugo
echo "Cloning Hugo to /opt/src/hugo"
if [ -d /opt/src ] || mkdir /opt/src
git clone https://github.com/gohugoio/hugo.git /opt/src/hugo
cd /opt/src/hugo
echo "Building Hugo now..."
CGO_ENABLED=1 go install --tags extended
cp $HOME/go/bin/hugo /opt/local/bin/hugo

# Clone Site
echo "Cloning site..."
git config --global credential.helper store
git clone $GITREPO /opt/hugosite
cd /opt/hugosite
echo "Updating submodules..."
git submodule update --init --recursive

# Modify nginx default config
echo "Modifying nginx config..."
sed -i 's/share\/examples\/nginx\/html/\/opt\/hugosite\/public/g' \
/opt/local/etc/nginx/nginx.conf
svcadm enable nginx

# Setup Automated Script
echo "Automating the updates\!"
cat << EOF > /opt/local/bin/auto-update.sh
#!/usr/bin/bash

while true
do
        cd /opt/hugosite
        /opt/local/bin/git pull
        /opt/local/bin/git submodule update --init --recursive
        /opt/local/bin/hugo
        sleep 600
done
EOF

chmod +x /opt/local/bin/auto-update.sh
npm install -g smfgen
smfgen -i site-update -l 'Example Site Auto-Update Service' \
-s '/opt/local/bin/auto-update.sh' -d /opt/www-fakewebsite \
-eHOME=/root > /tmp/update.xml
svccfg import /tmp/update.xml

echo "Awesome, you're all setup now\!"
echo "Just push changes to the git repo you specified\!"
```
