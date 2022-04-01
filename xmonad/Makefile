all: submodules build install

submodules:
	git submodules update --init --recursvie

build: stack.yml xmonad/ xmonad-contrib/
	stack build

install:
	stack install

