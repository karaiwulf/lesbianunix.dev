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
	hugo --config ./config-am.toml

package: all
	if [ ! -d ./pkg ] && mkdir ./pkg
	tar czvf ./pkg/www-lesbianunix.dev.tgz ./public/*
	tar czvf ./pkg/gemini-lesbianunix.dev.tgz ./public-gg/gemini/*

clean:
	rm -rf ./public/ ./public-gg/

clean-all: clean
	rm -rf ./pkg

