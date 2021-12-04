+++
title = "Hack the Box - The Needle"
date = "2021-12-03T23:05:55-06:00"
author = "Kararou Ren"
authorTwitter = "" #do not include @
cover = ""
tags = ["hackthebox", "hardware"]
keywords = ["hackthebox", "hardware", "hack", "hacking", "challenge"]
description = "A write up of the Hack the Box Hardware Challenge 'The Needle'."
showFullContent = false
readingTime = false
+++

# The Needle


## Write Up

`file firmware.bin` returns:
```
firmware.bin: Linux kernel ARM boot executable zImage (big-endian)
```

While searching the internet for this kind of file, I found that there's a
nifty little tool called `binwalk` specifically designed to extract the Linux
file system from these files.

Pretty easy to use, too!  `binwalk --extract ./firmware.bin`

I spun up the challenge instance and connected to the port that it specified
using netcat `nc <ip> <port>`  This showed me that it was running some sort of
login server, unencrypted.  Likely telnet.  This opens up a tonne of options to
search for, such as "login", "telnet", and the normal passwd files.

I decided to run a search for the term "login".  I found the following:

```
cd _firmware.bin.extracted && grep -rn "./" -e "login"
...
./telnetd.sh:9:		telnetd -l "/usr/sbin/login" -u Device_Admin:$sign	-i $lf &
...
```

Woah, it really can't be that easy right?  This defines a user for login in
telnet.  Specifically it defines a user "Device\_Admin", with a password in a
file called "sign".  So I did the thing to find a file with a certain name.

`find ./ -name sign`

This returned exactly two results.

```
./sign
./squashfs-root/etc/config/sign
```

They both contain the same text (I think something failed during the binwalk,
but who knows?).  Time to go back to the firmware instance.  This time I used
telnet.

`telnet <ip> <port>`

I supplied user "Device\_Admin" and the password from the sign file.
Immediately met with a user prompt, I was given the opportunity to `cat
flag.txt` and got the flag.

