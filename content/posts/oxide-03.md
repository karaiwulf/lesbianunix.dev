+++
title = "0x1DE - Work Samples"
date = "2021-09-02T08:00:00-06:00"
author = "Kararou Ren"
authorTwitter = "karaiwulf" #do not include @
cover = ""
tags = ["oxide", "candidate-materials"]
keywords = ["oxide", "candidate materials", "work samples"]
description = "The first of four major questions of the Oxide Candidate Materials."
showFullContent = false
draft = false
+++

So its been a bit.  Life has been getting in the way of doing things,
unsurprisingly.  I'm still working on this, but between my already hecktick
work, the additional duties I have in managing and maintining a production
micro cloud, my family life, and a recent move into a datacenter, I've have a
very hard time being able to sit down and do anything other than sleep.
Hopefully I'll get some time to write this out and exist in a more normalized
way so it doesn't drop two weeks from when I started it.

Anyway, the next few posts are going to be the hard ones.  They're a bit drawn
out.  Much longer form questions.  These will be especially hard for me, as
they are asking me to reflect upon my work.  In all sorts of different ways.  I
haven't had terribly big projects, nor do I feel like anything I've done is all
that exemplary.  But here we are.  I have to think really hard about what I
want to write over the next few posts.

### Work Samples

```
The ultimate measure of an engineer is our work. Please submit at least one
work sample (and no more than three), providing links if/as necessary. This
should be work that best reflects you as an engineer -- work that you are proud
of or you feel is otherwise representative of who you aspire to be as an
engineer.  If this work is entirely proprietary, please describe it as fully as
you can, providing necessary context.
```

So I have a few projects I could talk about here.  Both professional and
personal, but none that I'm particularly proud of.  If I'm honest with myself,
I'm not exactly much of an engineer.  Ironic, given the name of my blog, I
know.  I'm not much of a developer.  I want to be both.

I've dabbled in pretty much every realm of computing, from a garbage homebrew
computer based around the [FT3](https://en.wikichip.org/wiki/amd/packages/ft3)
Functional Datasheet (that's another story entirely), the embedded work I've
done for keyboard design with the Atmel AT90USB at its heart, to the ICS
wannabe Raspberry Pis that controlled my hydroponics setup.  While all of these
projects are "inspired", none of them are particularly note worthy.  And all of
my software projects have been, well, related to my education at best, or
dysfunctional half-baked ideas that don't pan out well at worst.

Except for one.

During my job where I wore every hat possible, I played at developer.  Nothing
serious.  I wrote high performance Python (believe me, words I didn't think I'd
ever say either) that was used to scrape data from darkweb hacker forums, then
process that data and get it ready for consumption by ElasticSearch.  It was
pretty slick.  Get blocked?  Just spin up a new instance in a Docker container
somewhere else.

I utilized Flask to give users a nice web-control panel (in basic HTML, I'm
very much not a web-dev by any stretch of the means, no single page apps for
me).  I utilized a tor control module to get tor information and refresh the
route used to access the sites for every new crawl.  I even used proper custom
built Scrapy middleware to route through tor and parse each returned page for
individual posts, then write those to a file in JSON-lines format for easy
ingestion into the ELK stack.

I had a working prototype in a month or so, but there was a problem with my
docker compose setup script, so a few weeks after that, I had everything set to
get it exporting data to ELK from a brand new setup.  And it worked.  Every
site the tech gave it ended up being ingested to the ELK stack fairly quickly,
too.  And the scheduled updates took even less time.

There was a small problem though.  Some of the sites were using fairly easy to
beat captcha's for login, and the crawler didn't work on those sites.  So,
clever problems require clever solutions.  I ended up hooking into an optical
character recognition system specially designed for captcha recognition and
feeding the image in.  It worked, but not nearly well enough for my liking,
only getting it right about 30% of the time.

So I started collecting and labeling captchas from everywhere I could.  I
decided I'd build my own captcha OCR using TensorFlow and a lot of clever
tricks and pre-processing.  For this, I had help from my former boss, who'd
been promoted.  He was, after all, a data-scientist, why not leverage him?  I
had only half of my target dataset collected, around 5000 captcha images, when
I'd been fired.

Lessons learned... don't be trans, don't give a company free work, and
definitely don't accidentally miss a meeting, and always ask for calendar
invites to meetings your boss decides you have to attend outside of your work
hours.

Remind me that if I decide to apply for Oxide in any capacity I need to come
back and clean these up so they sound more professional and... actually give
explanation instead of being a little vague.

