+++
title = "Care and Keeping of Joyent's Triton Datacenter"
date = "2021-06-22T03:43:26-06:00"
author = "Kararou Ren"
authorTwitter = "karaiwulf" #do not include @
cover = ""
tags = ["UNIX", "SmartOS", "Triton", "casual", "guide"]
keywords = ["Triton", "Data-Center"]
description = "A guide of the perils of Joyent's Triton DataCenter."
showFullContent = false
draft = false
+++

## A Little Background

(aka: Why Ren cares so much despite all the trouble)

In 2008, I got my first laptop that was mine enough to be able to begin my
experimentation with other operating systems.  I had previous experience with
Solaris, due to my father and his job, so my first steps into the world of UNIX
started there.  I'd downloaded OpenSolaris and got to work.  Years later when I
wanted to install something a little more familiar than Linux or FreeBSD, I go
to look for an OpenSolaris iso.  Much to my dismay, OpenSolaris is dead, after
the goons at Oracle closed all the sources.

Most people would quit their search at this point, but my brain doesn't work
quite like that.  I kept pushing at the problem.  I tried out Oracle Solaris 11
for a few weeks.  I played around with Solaris 10, but neither of them offered
me a good look into the OS/NET stack like I wanted.  Eventually, I discovered
that a fork of OpenSolaris was still alive and kicking:
[Illumos](https://illumos.org).

So I ran OpenIndiana on everything I could.  It was beautiful.  Familiar.
Wonderful.  A little bit later, I discover SmartOS, right in time, while I was
going to school for cyber security.  Containerization was a big talking point.
Everyone was on about Docker and how cool it was.  I will admit, it is very
cool, but the security around it at the time was a little bit sketchy at best.
I mean, I'd just read a few stories about how people were able to break out of
Docker containers!

So I built my home lab around SmartOS, a core component to my digital life and
sense of security.  When I wanted to start expanding, I figured I aught to look
into a decent way to orchestrate multiple SmartOS compute nodes.  Thus enters
the Triton DataCenter.

Triton is an open source stack of software designed specifically to orchestrate
an entire public cloud.  Everything from an api for external control, down to
the operating system itself.  All wrapped up in a nice little installer package
and very minimal networking setup required to get it all go.  So I started
using it, but it came with a few problems.

## Tips and Tricks

First, I'd discovered that *the headnode should not be treated as a general
purpose compute node with extra stuff on it*.  They warn about this, but I
figured that maybe it was just under true datacenter-scale load that it was
true.  Not a chance.  Don't provision zones on the headnode.  Use other
members of the cluster for provisioning.

Second, I'd accidentally included the headnode in my planning for the VXLan
setup.  The headnode will slowdown exponentially if you do this.  I have no
idea why, either, but maybe one day I'll ask the devs what particular set of
things happen to make this a bad idea (or maybe I'll debug it myself).

Third, provision high availability if you have the space for it in your
deployment.  No really.  High availability will help distribute the load and
actually improves the reliability of your cluster, even in a 5 node setup.
I've accidentally broken and destroyed a core zone irrepairably just by poking
around (admittedly doing so while mildly impaired).

Fourth, **read the manual**.  Joyent's manuals are all very nice and have a
decent depth to them.  The only caveat is that they are all over on github, and
not included with the software (maybe they are, but if so, I haven't been able
to find them).  You can start with the [Triton Architecture
Document](https://github.com/joyent/triton/blob/master/docs/developer-guide/architecture.md).
Yes, it *is* that good.

Fifth, nearly everything about the cluster itself can be controlled using
`sdcadm`, a fancy tool that manages updates, maintenances, and deployments.
Make sure you know how to use it, though, because accidentally doing things in
the wrong order can **and will** break the headnode and prevent all compute
nodes from booting.  I have done this on a live deployment.  It sucks to have
everything ripped out from under you, and not have enough time or resources to
properly debug what happened.  I'm *still* recovering from that mistake.

Sixth, most hardware is supported, even if its not on the HCL.  With that in
mind, its still sometimes hard to work around specific issues with older
hardware.  My cluster runs some Dell servers and some HP servers.  For some
reason, occasionally the HP servers will take extra long to provision a zone (I
will debug this at some point, when I get the time).  Other times, the Dell
servers simply stop responding due to awkward network hangs or the IPMI
interface throwing a fault (I can't fix this, as network latency is due to
hardware itself and IPMI throwing fault and causing the system to halt is a
good thing).

## Problems with HA deployments

There are some issues with using ZooKeeper to manage clustering of high
availability services.  For example, if you have total loss of power in the
datacenter, or otherwise have every node go down at the same time, the way
[binder](https://github.com/joyent/binder) is configured, it has to have the
majority alive in order to come up.  This can cause issues during internal
communications, since all of the internal APIs communicate to eachother using
binder provided DNS names.  In my experience, this also prevents other nodes
from booting, though that may have been an issue specific to my setup (I cannot
replicate it, though I desperately want to know *why* it happened).

Additional issues I've found is that host instability can cause wild things to
happen with [manatee](https://github.com/joyent/manatee).  Specifically, I
accidentally dropped a manatee node on to a server that can receive large load
from other database servers sharing the same compute resources.  Under these
intense loads, network connections will remain to be alive and happy.  Even
ZooKeeper continues to report that it is *in fact* the primary manatee node.
However, it will refuse to let the topology change, and all replication to
other nodes will cease *entirely*.

In order to resolve that, I had to tell the server to refresh all of its
configuration (by booting into a smartos live usb and clearing the
configuration file).  After that, I let manatee sync back up, then deposed it
as primary and went through the rather quick process of rebuilding it.
However, none of this would have been an issue if I'd had been paying attention
to my...

## Monitoring (and *Dashboards*)

Monitoring is really important for these things in order to keep them well
tuned and to quickly recover from faults.  Triton includes monitoring, but
requires a few things to be setup.  You'll need to setup
[CMON](https://github.com/joyent/triton-cmon),
[CNS](https://github.com/joyent/triton-cns), and
[Prometheus](https://github.com/joyent/triton-prometheus) before you can even
setup [Grafana](https://github.com/joyent/triton-grafana).

According to the documentation, this should all just work once its setup.  I
had to go in and create some new authentication certificates for prometheus in
order for it to pull data correctly.  

## Why Triton is Worth It

Despite all of the above problems I've been through with Triton, its still a
very stable bit of software.  Once its up and kicking, it won't have issues
outside of total power loss or host instability.  It will even outlast other
systems (such as Linux and K8S) for stability in the face of hardware faults.
That's amazing to me.  It may have a learning curve, but ultimately, the easy
command line interface, the truly amazing resilience, and the ability to have
the best of Illumos *and* Linux is a pure joy.

