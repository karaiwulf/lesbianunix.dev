---
title: "Krypt0"
date: 2021-08-24T04:23:53-06:00
draft: false
---

## Krypt0

An experiment in automation and design.  Purpose built to automate as much of a
penetration test as possible.

With several components in development, Krypt0 is very much a work in progress!

You can read more about each component below.  But before, a quick note on
naming... each of these sub-projects is named after a fictional lesbian.  I
find it very fitting.

```
emily - The backend, job manager, auth-source, etc.
korra - A portscanner service
helena - The web-based front end
adora - the cli-based front end
jill - An exploit and payload compiler
```

### Emily

Emily is the application thats under development currently.  She will use
Joyent's [Manatee](https://github.com/joyent/manatee) as her primary
data-store and the warp crate to offer a REST API interface.

