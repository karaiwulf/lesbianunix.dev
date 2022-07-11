+++
title = "How To Setup and Use Triton Fabric Networks"
date = "2022-07-10T23:05:52-05:00"
author = "Kararou Ren"
authorTwitter = "" #do not include @
cover = ""
tags = ["tritoncli", "triton", "how-to"]
keywords = ["mnx", "cli", "node-triton", "fabric"]
description = "A brief how-to for end-users of Triton Fabric networks."
showFullContent = false
readingTime = false
+++

Triton offers private virtualized networks to end-users, if the cloud operators have set it up.  This allows you to create more flexible networks than may be available through the cloud provider's own infrastructure.  Using it is simple once you've got the hang of it.

### VLANs

VLANs, or Virtual Local Area Networks, add a tag to the ethernet frame being sent.  More can be read about that on Wikipedia or Cisco's documentation; however, what you need to know as an end user is that you can create 4094 separate private networks.

You can access these using `triton vlan` and its subcommands.

```
spicywolf@cremia:~$ triton vlan ls
VLAN_ID  NAME     DESCRIPTION
1337     default  Ren's Default Network
```

You can use VLAN IDs 2 through 4095.  These VLANs are specific to your account, so nobody else can see or use them.  You can create one like so:

```
spicywolf@cremia:~$ triton vlan create -n name -D "Some Description" 55
Created vlan name (55)
spicywolf@cremia:~$ triton vlan ls
VLAN_ID  NAME     DESCRIPTION
55       name     Some Description
1337     default  Ren's Default Network
```

In Triton, every VLAN must have a name, but the description can be ommited with no issues.  For more information on the subcommands available to you, simply issue a `triton help vlan` or `triton vlan help <command>` with your subcommand of choice.

### Networks

Now that you've got a VLAN setup, we can create a network.  You can divide up any of the private IP spaces up however you please for this (10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12).  At KCRL we like to use the 172.16.0.0/12 range for all of our internal networks to avoid conflicts within other people's networks, a limitation of our current setup requires us to use VPNs for access.

To list out your current networks, issue `triton network ls` or `triton networks`:

```
spicywolf@cremia:~$ triton networks
SHORTID   NAME     SUBNET          GATEWAY        FABRIC  VLAN  PUBLIC
e0e2eef9  Haeven   172.17.99.0/24  172.17.99.254  true    1337  false
3c4f1258  public   -               -              -       -     true
```

As you can see, my fabric network uses the 'default' VLAN (1337) that I'd previously setup.  To create a new fabric network, we can do:

```
spicywolf@cremia:~$ triton network create -n name -D "Some Description" -s 192.168.100.0/24 -S 192.168.100.1 -E 192.168.100.253 -g 192.168.100.254 -r 8.8.8.8 -r 8.8.4.4 55
Created network name (3ce6352b-0df6-4101-b8af-a32f98a287c0)
```

Woah, okay, lets break that down, because its actually a lot.

```
spicywolf@cremia:~$ triton network create \
    -n name -D "Some Description" \ # This is the Name and Description of the Network
    -s 192.168.100.0/24 \ # The Subnet the network should use
    -S 192.168.100.1 -E 192.168.100.253 \ # The Start and End provisionable range of addresses available to instances
    -g 192.168.100.254 \ # The gateway address, here Ive used the last host-address in the subnet
    -r 8.8.8.8 -r 8.8.4.4 \ # Define up to 3 DNS resolvers for the network
    55 \ # The VLAN ID you created earlier
```

For more information on this, issue `triton network help create` and it'll spit out a tonne of useful information and even some examples!

The newly created 'name' network shows up like so:

```
spicywolf@cremia:~$ triton networks
SHORTID   NAME     SUBNET            GATEWAY          FABRIC  VLAN  PUBLIC
e0e2eef9  Haeven   172.17.99.0/24    172.17.99.254    true    1337  false
3ce6352b  name     192.168.100.0/24  192.168.100.254  true    55    false
3c4f1258  public   -                 -                -       -     true
```

### Instances

Right, okay, so you have the VLAN, you have the network, but you won't be able to put instances on the network and be able to login or otherwise access them, due to Triton's `sdc-nat` zone really only giving the network internet access (no port forwarding, or other access!).  So the easiest way to setup access to instances on the inside of a fabric network is to create a dual-homed jump-host.

```
spicywolf@cremia:~$ triton create -n name-jmp -N public -N name minimal-64 wittl
Creating instance name-jmp (5ccd3092-e21f-48ad-8bb9-7c32523b025e, minimal-64@20.3.0)
```

You must specify the public network first, so it is assigned as the primary nic in the system.  For those of you wondering about the `wittl` package, its our offering that only has 64m of RAM available to it.  Since this is just a jump host, it shouldn't be an issue.

If you aren't particularly familiar with what all of this means, please see `triton help create`, `triton help packages`, and `triton help images`.

Now that you've created your jump host, we can start creating instances on the 'name' network, and then using ssh to test out how they work.  Really, the big difference here from normal creation is the addition of some special tags.

According to the help text from `triton help ssh`, we should be specifying some tags to be able to ssh to these machines: `triton.ssh.proxy`

To populate this tag at creation time, we can use the `-t` option.  The tag will work with the shortid, name, or full uuid of any instance, here I use the name of the jump instance we created earlier:

```
spicywolf@cremia:~$ triton create -n name-instance0 -N name -t tritoncli.ssh.proxy=name-jmp base-64 nyarmal
Creating instance name-instance0 (b913333e-b783-4bdc-bc22-e7444e0a2b6b, base-64@20.3.0)
```

To add the tag after creation of the instance:

```
spicywolf@cremia:~$ triton create -n name-instance1 -N name base-64 nyarmal
Creating instance name-instance1 (87c9a1e6-32ef-49dc-9b84-b95acd24e5c4, base-64@20.3.0)
spicywolf@cremia:~$ triton instance tag set name-instance1 tritoncli.ssh.proxy=name-jmp
{
    "tritoncli.ssh.proxy": "name-jmp"
}
```

You should now be able to use a fabric network as you would any other.

