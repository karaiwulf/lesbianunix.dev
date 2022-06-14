+++
title = "Reflections on .NET SDK CLI"
date = "2022-06-13T21:34:28-05:00"
author = "Ren Kararou"
authorTwitter = "" #do not include @
cover = ""
tags = ["programming", "csharp", ".net"]
keywords = ["microsoft", "dotnet"]
description = "A few words on the entire .net situation"
showFullContent = false
readingTime = false
+++

So, I was hired to do a job in C# recently.  Up until now I've been using a
Windows desktop to write code for this project.  Today, I setup the [dotnet
cli](https://docs.microsoft.com/en-us/dotnet/core/install/linux) and the
[OmniSharp-Roslyn](https://github.com/OmniSharp/OmniSharp-Roslyn) Programming
Language Server (or more accurately, the omnisharp-vim module), and plugged it
into my ALE config (more on this in a future blog post).

Honestly, the only thing I'm missing out on is the nice debugger at this point,
and I greatly appreciate that Microsoft has made the roslyn toolchain open
source.  

I feel like anyone paying for Visual Studio in the year 2022 hasn't figured out
that Visual Studio Code (or in my case, vim) is just as good purely because of
the work the community has poured into making life nice for those of us not on
Windows.

I still don't trust Microsoft to do the right thing, but this experience has
been painless, and rather nice.  I never expected official Microsoft compilers
on my Linux install, yet here we are.  Modern technology.

