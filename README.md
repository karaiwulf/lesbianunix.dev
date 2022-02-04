The sources for the website and gemini capsule at lesbianunix.dev

Contributions will be reviewed, so feel free if you want to write some stuff I
guess.

It's hugo sources, so you'll have to have hugo.

To build:

1. Install Hugo

2. clone repo

   `git clone https://github.com/karaiwulf/lesbianunix.dev`

3. update submodules

   `git submodule update --init --recursive`

4. build site

   `hugo # for development add -D`

To add a new post, follow the above instructions, then:

`hugo new posts/url-title.md`

You can replace url-title with whatever you want, it will be the url part.  For
example: content/posts/asm3.md renders as https://lesbianunix.dev/posts/asm3/

