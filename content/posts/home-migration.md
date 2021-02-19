+++
title = "Home Migration"
date = "2021-02-18T20:10:27-07:00"
author = "Kararou Ren"
authorTwitter = "karaiwulf" #do not include @
cover = ""
tags = ["UNIX", "Linux", "SPARC", "Raspberry Pi"]
keywords = ["Migration", "Homelab"]
description = "Planning a move from a SPARC server to a cluster of RPi's"
showFullContent = false
+++

# Current Setup

The current setup supporting [Ceres](http://ceres.kararou.space), is a 2U
server, a bit of an exotic one in the current age.  The [Sun
Microsystems](https://en.wikipedia.org/wiki/Sun_Microsystems) [Sun Fire
T2000](https://en.wikipedia.org/wiki/Sun_Fire_T2000).  Its a cute system,
running an UltraSPARC T1 processor (codenamed Niagra) with 64GB of DDR2 ECC
buffered RAM.  I fitted it with solid state drives in all of its drive bays as
well (for some reason, they don't actually report SMART data, so the chassis
thinks they are all broken).

I've installed [Tribblix](http://www.tribblix.org/) on it (specifically, [0m20
SPARC](https://pkgs.tribblix.org/iso/tribblix-sparc-0m20.iso), which is
unfortunately the latest release).  You have to configure an IP address using
`ipadm`, then update using the `zap` utility ([zap
documentation](http://www.tribblix.org/zap.html).  This server was setup with
an nginx instance and a bind9 instance.

The nginx was setup with a hugo-generated static site in mind, while the bind9
server replicates dns from the [main location](https://kararou.space).

I'm not satisfied with this setup for a few reasons, though.  The primary
reason is the lack of [Zone](https://en.wikipedia.org/wiki/Solaris_Containers)
support in the SPARC version of Tribblix.  Another major reason is that
software available from the common repos doesn't appear to have any
consistency.  Bind will install to normal places, while nginx installs (and is
configured from) `/opt/tribblix/nginx`.  This lack of consistency in the main
software repository of an OS troubles me.

# Planned Setup

I've never played around with Kubernetes to manage docker containers, so my
plan is to have 4 or so K8S Raspberry Pi 3 Model B, though eventually I could
upgrade to the 4 or 8 GB of RAM versions of the Pi 4.
