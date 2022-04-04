all: submodules build install

submodules:
	git submodule update --init --recursive

build: stack.yaml xmonad/ xmonad-contrib/
	stack build

install:
	stack install

