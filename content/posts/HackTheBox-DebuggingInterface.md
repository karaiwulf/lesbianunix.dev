+++
title = "Hack the Box - Debugging Interface"
date = "2021-12-03T23:03:08-06:00"
author = "Kararou Ren"
authorTwitter = "" #do not include @
cover = ""
tags = ["hackthebox", "hardware", "challenges"]
keywords = ["hack", "hacking", "hack the box", "hardware", "challenges"]
description = "A write up for the Hack The Box Hardware Challenge 'Debugging Interface'."
showFullContent = false
readingTime = false
+++

# Debugging Interface

The debugging interfaces challenge on Hack the Box.
([link](https://app.hackthebox.com/challenges/207))

## Writeup

Using `unzip` on the .sar, we get two files, a digital-0.bin and meta.json.

Running `xxd digital-0.bin | head -1` produces the following output:

```
00000000: 3c53 414c 4541 453e 0100 0000 6400 0000  <SALEAE>....d...
```

Not knowing what a `<SALEAE>` filetype is, I ran a google search and found that
Saleae produces logic analysers and some [associated
software](https://www.saleae.com/downloads/).  I downloaded the free
`Logic-2.3.40-master.AppImage` and launched it.  I loaded up the .sar file into
it and started looking.  Visually analysing the waveforms, I found that the
serial rate was at 31210 baud, and set the application to view Async Serial at
31210 baud and then set the application to view as terminal data, which
presented the flag. 

