+++
title = "Triton Backups"
date = "2021-08-01T20:58:25-06:00"
author = "Kararou Ren"
authorTwitter = "karaiwulf" #do not include @
cover = ""
tags = ["triton", "backups"]
keywords = ["UNIX", "triton", "backups"]
description = "The short 'how-to' to fixing sdc-backup."
showFullContent = false
+++

Okay, really though, backups are wildly important in the year 2021.  Please
use them.  ***Please please please have a backup and restore plan in place!***

Alright, now that we have that out of the way.  You are looking to run backups
on your Triton Datacenter.  You're poking around on the headnode and notice
that there's a command called `sdc-backup`.  When you run it, there's no help
it just tries to make a backup.  It will fail though, complaining that it can't
find the command `sdc-manatee-stat`.  You can run whatever searches you want,
it doesn't exist.  So you'll have to create it.

Its a fairly simple script.

```bash
#!/bin/bash
# this file is located at /opt/smartdc/bin/sdc-manatee-stat
sdc-login manatee ' . /root/.bashrc ; /opt/smartdc/manatee/node_modules/.bin/manatee-adm status'
```

Then, its as simple as running `sdc-backup` and waiting a relatively short
amount of time... unless you're running in a High Availability mode.  Because
you'll have multiple manatee instances to choose from, `sdc-backup` will wait
endlessly.  So quick and easy work around, have it always pick the instance on
the headnode be adding `-c 0` as the first argument of `sdc-login`.

```bash
#!/bin/bash
# this file is located at /opt/smartdc/bin/sdc-manatee-stat
sdc-login -c 0 manatee ' . /root/.bashrc ; /opt/smartdc/manatee/node_modules/.bin/manatee-adm status'
```

And now you can automate your backups... sortof.  Your backups will be faulty
if manatee0 enters the deposed state.  You'll have to keep an eye on your HA
service cluster, but you should be doing that anyway!

