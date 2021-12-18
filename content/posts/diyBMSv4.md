+++
title = "diyBMSv4 Analysis"
date = "2021-12-06T13:07:29-06:00"
author = "Kararou Ren"
authorTwitter = "" #do not include @
cover = ""
tags = ["analysis", "diyBMS"]
keywords = ["battery", "diy", "lithium"]
description = "An analysis of stewartpittaway's diyBMSv4"
showFullContent = false
readingTime = false
draft = true
+++

## Why

I've had an interest in Lithium Ion batteries for a while.  I've even got some
very basic designs for a supercapacitor-backed 12V car battery replacement.
Problem?  The battery management system is an off-the-shelf part.  I want to
integrate it into the board so its sleek and I don't have a battery pack with a
BMS taped to it.

I might as well look at some open source designs to figure out how I'd like my
systems to manage their batteries.  In my research into open source designs, I
found [stewartpittaway](https://github.com/stewartpittaway)'s
[diyBMSv4](https://github.com/stewartpittaway/diyBMSv4).  So why not?  Let's
analyse this thing and figure out how it ticks.

## Overview

Its composed of many parts: the controller itself, a shunt board, and as many
cell monitoring modules as there are cells in the pack.  These boards all talk
to eachother through i2c, with the exception of the shunt board, which talks
RS485 to the controller board.  This all feels very normal based on designs
available from TI and NXP.

Other communication methods available on the shunt board are MODBUS and i2c.
While i2c is available, its recommended to use either MODBUS or RS485 to
interface with it, as these are industry standard protocols for other
industrial applications.  Communication methods on the controller board are
pretty standard with options like CAN, RS485, and i2c.  An interesting addition
is WLAN, which presents a web interface for configuration and monitoring.

It does not appear that the web connection is an optional feature, but during
my cursory overview I haven't dug into the firmware.

Overall, this is a pretty slick design, even if it has some glaring issues.

## Controller Board

In my opinion, this controller board should be made of better stuff.  That
being said, I understand the ease of programming an off the shelf
microcontroller board such as the ESP32-DevKit.  Even then, there are parts
from TI, NXP, and ST that are just as easy to design around.

But all of those parts comes with a price.  For designs that are geared
toward hobbyists working on diy PowerWalls, the ESP32 DevKit is readily
available, cheap, and easy to work with.  Testing new code?  Plug it in and
reprogram it.  Break the module?  Pop a new one in.

A number of the parts were selected from LCSC specifically so the boards could
be populated before being shipped off from JLCPCB.  It makes manufacturing far
easier, without a doubt.

There are a few key features that are important: transmit lines on the i2c bus
are optoisolated using an EL3H7-G module
([datasheet](https://everlightamericas.com/index.php?controller=attachment&id_attachment=2584)).

