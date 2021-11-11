# Build variables

all: html gemini

pull:
	git pull
	git submodule update --init --recursive

html:
	hugo

gemini:
	python3 ./themes/Hugo-2-Gopher-and-Gemini/src/hugo2gg.py

alphamethyl: pull
	hugo --config ./altconf/alphamethyl.toml

package: all
	if [ ! -d ./pkg ]; then mkdir ./pkg; fi
	cd ./public; tar czvf ../pkg/www-lesbianunix.dev.tgz ./*
	cd ./public-gg/gemini; tar czvf ../../pkg/gemini-lesbianunix.dev.tgz ./*

clean:
	rm -rf ./public/ ./public-gg/

clean-all: clean
	rm -rf ./pkg

