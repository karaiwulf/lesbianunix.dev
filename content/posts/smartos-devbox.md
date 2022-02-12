+++
title = "How to setup a SmartOS dev box"
date = "2022-02-12T11:00:40-07:00"
author = "Kararou Ren"
authorTwitter = "" #do not include @
cover = ""
tags = ["how-to", "smartos", "triton", "joyent"]
keywords = ["development", "environment"]
description = "Ren sets up a remote development box on a smart machine using Triton"
showFullContent = false
readingTime = false
+++

### Introduction

Hi folks, been a bit since I've written up a post, I know, I'm sorry.  I've
been busy.  As a part of one of the projects I've been working on, I've decided
to target SmartOS specifically.  This isn't anything new, as I have quite a
fixation on it (it powers the [Kararou Computer Research
Lab](https://kararou.space)'s cluster, so of course I'm going to leverage it).

### Create an Instance

Create your instance however you do that, mine followed a route like so:

List Triton networks:

```
$ triton networks
SHORTID   NAME                   SUBNET            GATEWAY        FABRIC  VLAN  PUBLIC
429ae81e  My-Fabric-Network      192.168.128.0/22  192.168.128.1  true    2     false
c9158b8d  barr0wnet-kararou-pop  -                 -              -       -     true
2a306b7c  dmz                    -                 -              -       -     true
dd047ad4  external               -                 -              -       -     true
8c7adcaf  hacks                  192.168.137.0/24  192.168.137.1  true    666   false
7b56a4b1  sdc_nat                -                 -              -       -     true
e24f5e94  server                 -                 -              -       -     true
```

We simply need to know which network to use, and I have a few of them setup and
available to me.  I'm going to pick "server" because its the network used for
non-dmz servers.

Next, look at the available packages:

```
$ triton pkgs
SHORTID   NAME                  MEMORY  SWAP  DISK  VCPUS
b6690689  teeny                    64M  256M   10G      1
418650a9  smol                    256M    1G   10G      1
cd55c0c5  nyarmal                 512M    2G   20G      2
f6a99059  lorge                     1G    4G   20G      2
186d623b  insanyanty                2G    6G   20G      4
d1bf309d  herculenyan               3G    8G   20G      5
eefa2bc1  gignyantic                4G   10G   20G      6
1509016f  considerable-chonker      6G   12G   20G      7
2de9db76  aaaaaaa                   8G   16G   40G      8
edfb4ba3  aaaaaaa                  10G   20G   40G     10
```

These are the packages I have available.  I'm going to pick a nyarmal sized
instance because I can dynamically resize these as I need to.

The last thing we have to do is ask Triton to let us know what images we have
available.

```
$ triton imgs
SHORTID   NAME                    VERSION       FLAGS  OS       TYPE          PUBDATE
7b5981c4  ubuntu-16.04            20170403      P      linux    lx-dataset    2017-04-03
c193a558  base-64-lts             18.4.0        P      smartos  zone-dataset  2019-01-21
4feac886  ubuntu-certified-18.04  20190514.1    P      linux    zvol          2019-05-22
616c7421  ubuntu-certified-16.04  20190628.1    P      linux    zvol          2019-07-03
9aa48095  ubuntu-certified-18.04  20190627.1.1  P      linux    zvol          2019-07-03
e75c9d82  base-64-lts             19.4.0        P      smartos  zone-dataset  2020-01-07
9bcfe5cc  debian-10               20200508      P      linux    zvol          2020-05-08
9ad5a702  minimal-64-trunk        20201019      P      smartos  zone-dataset  2020-10-19
2d8225e4  base-64-trunk           20201019      P      smartos  zone-dataset  2020-10-19
1f538e62  pkgbuild-trunk          20201019      P      smartos  zone-dataset  2020-10-19
800db35c  minimal-64-lts          20.4.0        P      smartos  zone-dataset  2021-01-11
1d05e788  base-64-lts             20.4.0        P      smartos  zone-dataset  2021-01-11
0bf06d4d  ubuntu-20.04            20210413      P      linux    lx-dataset    2021-04-13
f9d127e8  void                    20210413      P      linux    lx-dataset    2021-04-13
62aa54b0  barrow-base             1.0.0         P      smartos  zone-dataset  2021-10-31
108ee646  barrow-bind             1.0.0         P      smartos  zone-dataset  2021-10-31
74b6fe0c  rust-stable             1.56.1        PS     smartos  zone-dataset  2021-11-03
ea7da286  rust-stable             1.57.0        P      smartos  zone-dataset  2021-12-20
088acaa4  rust-stable             1.58.0        P      smartos  zone-dataset  2022-01-13
```

I'm going to use base-64-trunk, as that affords me the latest pkgsrc packages;
however, during installation, I noticed that base-64-trunk doesn't have clang,
while base-64-lts@20.4.0 does.  So if you need clang, use that one instead.
We also have rust-specific packages thanks to our good friend,
[barrow](http://alphamethyl.barr0w.net/~barrow).

Now we can create the instance itself:

```
$ triton create -n devbox -N server base-64-trunk nyarmal
Creating instance devbox (b10998b8-97d1-4a2f-9914-6cd47dd61f7e, base-64-trunk@20201019)
```

Go ahead and do something for a few minutes, typical spinup time is around 46
seconds and run `triton ls` to see if its running yet.  You could also set
triton to wait for the instance to spinup by using the `-w` flag.

### Login and Setup

UNIX is fun.  I love it a lot.  Lets login.

```
$ triton ssh devbox
The authenticity of host 'devbox (X.X.X.X)' can't be established.
ECDSA key fingerprint is SHA256:YPSriDziNSbmsT/oCkgNitx9EWxV+mXlmgVv6YO2saY.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'devbox' (ECDSA) to the list of known hosts.
   __        .                   .
 _|  |_      | .-. .  . .-. :--. |-
|_    _|     ;|   ||  |(.-' |  | |
  |__|   `--'  `-' `;-| `-' '  ' `-'
                   /  ; Instance (base-64-trunk 20201019)
                   `-'  https://docs.joyent.com/images/smartos/base

[root@devbox ~]# 
```

Now lets get to setting up some fancy stuff, like a brand new user account that
has access to `pfexec`, and zsh, and the rest of our devtools.

First thing we want to do is update everything.

```
# pkgin up
reading local summary...
processing local summary...
processing remote summary (https://pkgsrc.joyent.com/packages/SmartOS/trunk/x86_64/All)...
pkg_summary.xz                                                100% 2326KB 581.6KB/s   00:04
# pkgin upgrade -y
```

The last command will proabably generate a lot of output, but don't worry.  Its
updating.

I like zsh, so I'm going to install it, along with the build-essential
metapackage and git, which isn't included in build-essential.  This might have
something to do with the fact that git-scm was the previous name of the
package.  Another little gem I'm going to install is mosh.  Its an addition to
ssh that makes things much nicer on mobile connections that cutout a lot.

```
# pkgin in -y zsh git build-essential mosh
```

This will also generate a lot of output.  Don't worry.  Its all going according
to plan.  Next we'll be setting up a non-root user.  To make things a little
more friendly, though, we will first create a primary group for that user.

```
# groupadd spicywolf
UX: groupadd: spicywolf name too long.
```

Oof.  Maybe it worked anyway, right?  (It did, of course).  Check /etc/group
to ensure you didn't get lolnope'd into oblivion.

```
# cat /etc/group
root::0:
other::1:root
bin::2:root,daemon
sys::3:root,bin,adm
adm::4:root,daemon
uucp::5:root
mail::6:root,postfix
tty::7:root,adm
nuucp::9:root
staff::10:
daemon::12:root
sysadmin::14:
games::20:
smmsp::25:
upnp::52:
xvm::60:
netadm::65:
slocate::95:
unknown::96:
nobody::60001:
noaccess::60002:
nogroup::65534:
maildrop::934:
postfix::901:
_pkgsrc::999:
spicywolf::1000:
```

Looks like it worked just fine.  Now lets create that user.  I want to have the
ability to `pfexec` (in place of sudo), so we'll be taking advantage of the
profiles built into SmartOS for RBAC.  To see a full list of roles, you can
simply `cat /etc/security/exec_attr`, but the one we care about here is
"Primary Administrator".

```
# which zsh
/opt/local/bin/zsh
# useradd -g spicywolf -G staff,games,sysadmin,netadm -d /home/spicywolf -m \
-s /opt/local/bin/zsh -c "Ren Kararou" -P "Primary Administrator" spicywolf
UX: useradd: spicywolf name too long.
UX: useradd: spicywolf name too long.
144 blocks
# passwd spicywolf
New Password: 
Re-enter new Password: 
passwd: password successfully changed for spicywolf
```

So that's basically just figuring out where zsh is installed to, creating user
spicywolf with primary group spicywolf and additional groups staff, games,
sysadmin, and netadm (no I don't know why they are named inconsistently, and I
don't care), setting a home directory of /home/spicywolf and creating it if it
doesn't exist (-m), then adding a comment of the user's name (it me lol) and
giving the user the "Primary Administrator" profile.  Again, the UX failures
are bogus hold overs from times long past.  It all still works.

The last command is setting the initial password for the user.

Now we get to test the user.  We are going to do this by pulling down ssh keys
from github.

```
# su - spicywolf
This is the Z Shell configuration function for new users,
zsh-newuser-install.
You are seeing this message because you have no zsh startup files
(the files .zshenv, .zprofile, .zshrc, .zlogin in the directory
~).  This function can help you with a few settings that should
make your use of the shell easier.

You can:

(q)  Quit and do nothing.  The function will be run again next time.

(0)  Exit, creating the file ~/.zshrc containing just a comment.
     That will prevent this function being run again.

(1)  Continue to the main menu.

--- Type one of the keys in parentheses --- q
devbox% 
```

The user works.  That's good.  I pressed q to exit the zsh configuration menu
and have it launch next time.

```
$ cd .ssh
$ wget -O authorized_keys https://github.com/karaiwulf.keys
```

Finally, lets test pfexec:

```
$ pfexec whoami
root
```

Perfect.  That works, and everything looks fancy.  Exit the user and root
shells, then login to test mosh.

```
$ mosh devbox
```

You should be all set now to go forth and write some code no matter where you
are.

