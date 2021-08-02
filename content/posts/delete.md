+++
title = "Accidental Deletion of CMON"
date = "2021-07-22T03:28:10-06:00"
author = "Kararou Ren"
authorTwitter = "karaiwulf" #do not include @
cover = ""
tags = ["recovery", "smartos", "triton", "UNIX"]
keywords = ["accidental deletion", "CMON", "triton"]
description = "I accidentally deleted my CMON zone and had to recover."
showFullContent = false
+++

`[root@headnode (us-west-0) ~]# vmadm delete 0<TAB><ENTER>`

Oh the tails of lost systems gone by.  Don't fret, though, because if you
accidentally delete a crucial zone, so long as its not the sole datastore
in use by Triton, that is [manatee](https://github.com/joyent/manatee), you'll
be fine.  Remember to keep [backups](/posts/triton-backups)!

Alright, so lets get to restoring whatever it is that's been deleted.  First,
the Triton service api is still going to have record of whatever has been
deleted, and that has to be deleted before we can redeploy it.  Once you've
logged into the headnode, test to make sure that that sapi is still accessible.

```
sdc-sapi /instances
```

You should get a large JSON dump that lists admin network IP addresses, UUIDs,
services, etc.  Now check for the instance you just deleted:

```
# Replace $UUID with the UUID of the instance you deleted.
sdc-sapi /instances/$UUID
```

If you get data back, it will be a short JSON blurb describing the information
about the instance that provides this service.  If you get information back,
then you'll have to delete it.  If you don't, you can skip right to redeploying
the instance using `sdcadm`.

```
# Replace $UUID with the UUID of the instance you deleted.
sdc-sapi /instances/$UUID -X DELETE
```

Once you've deleted the erroneous service instance record, you can begin
redeploying.

```
# Replace $service with whatever service you've accidentally deleted
sdcadm post-setup $service -s headnode
```

The new service instance should setup.  It will have a new IP address, but as
long as that isn't an issue, you should be goode.  Otherwise, you'll have to
use `sdc-sapi` to update the IP addresses of the service records, and
`sdc-vmadm` to update the actual nics themselves.

