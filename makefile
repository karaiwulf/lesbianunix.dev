# Build variables

all: html gg

pull:
	git pull
	git submodule update --init --recursive

html: pull
	hugo

gg: pull
	./themes/Hugo-2-Gopher-and-Gemini/src/hugo2gg.py

