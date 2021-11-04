+++
title = "0x1DE - Analysis Sample"
date = "2021-09-06T08:28:47-06:00"
author = "Kararou Ren"
authorTwitter = "karaiwulf" #do not include @
cover = ""
tags = ["oxide", "candidate-materials"]
keywords = ["oxide", "candidate-materials"]
description = "Putting on our science hats and entering the foreign world of Analysis"
showFullContent = false
draft = true
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

Instead, I will be recounting the tale of a simple bug in coreutils, because
honestly its the most interesting thing I've gotten to look at in the last four
years of my life.

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

When a customer calls in asking why the "Avail" and "Use%" in `df` don't
calculate to be the same thing, the number of reasons could be myriad.  I was
working as the UNIX/Linux SME consult on this particular ticket, but I ended up
doing most of the troubleshooting work, too.  

