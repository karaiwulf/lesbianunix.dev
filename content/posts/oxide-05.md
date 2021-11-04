+++
title = "0x1DE - Analysis Sample"
date = "2021-11-04T00:00:00-06:00"
author = "Kararou Ren"
authorTwitter = "karaiwulf" #do not include @
cover = ""
tags = ["oxide", "candidate-materials"]
keywords = ["oxide", "candidate-materials"]
description = "Putting on our science hats and entering the foreign world of Analysis"
showFullContent = false
draft = false
+++

Oh yes.  The much more familiar world of analysis.  Given I've been working as
an analyst more or less for the last four years, this is so very up my alley.
"Why doesn't this work?" is one of the most frequent questions in IT.  I won't
be recounting a tale of the time my web-scraper did some hillariously backwards
things (though maybe I *should* at some point tell that story), nor will I be
recounting the first time I interface with an API (turns out it wasn't a stable
platform).  Nor will I say anything about the reverse engineering test that was
given as a final for Systems 500 in school, though it was very much a fun test
(remember that `objdump` is *always* your friend on Linux systems).

I suppose I can talk about the many times that I've accidentally broken Triton
by sheer force of will.  And updates.  Triton is the most frustrating thing to
update.

# Analysis Samples

```
A significant challenge of engineering is dealing with a system when it
doesn't, in fact, work correctly.  When systems misbehave, engineers must flip
their disposition:  instead of a creator of their own heaven and earth, they
must become a scientist, attempting to reason about a foreign world. Please
provide an analysis sample: a written analysis of system misbehavior from some
point in your career. If such an analysis is not readily available (as it might
not be if one’s work has been strictly proprietary), please recount an incident
in which you analyzed system misbehavior, including as much technical detail as
you can recall.
```

Every single time I try to do anything with this I end up just feeling bad.
Honestly, pathological system misbehaviour is something I'm so entrenched in
that it just feels normal at this point.  I've had to track down code paths
from end point down to system call.  I've done this so much and so frequently
that I'm honestly tired of looking through code.  I just spent a month
disconnected and getting back into the flow of debugging and analysis.

I'm going to be honest, I've been debugging my Triton standup for the last
three days, almost all in one block, if not for a two hour jaunt to the store
and sleeping.  I was able to get the cluster working again, sortof.
Provisioning from cloudapi doesn't work, but provisioning from adminui does.  I
think I'm just going to reprovision a cloudapi to fix it.  I can't be bothered
to keep doing this, getting the blood and guts of Triton all over my terminal.

