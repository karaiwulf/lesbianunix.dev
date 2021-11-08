# Build variables

all: html gemini

pull:
	git pull
	git submodule update --init --recursive

html: pull
	hugo

gemini: pull
	./themes/Hugo-2-Gopher-and-Gemini/src/hugo2gg.py

alphamethyl: pull
	hugo --config config-am.toml

clean:
	rm -rf public/ public-gg/

