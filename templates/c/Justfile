run: build
	./build/example

build:
	#!/usr/bin/env bash
	if [ ! -d build ] || [ ! -f build/meson-private/coredata.dat ]; then just _wipe; fi
	mkdir -p build/stamps

	old="$(< build/stamps/src)"
	new="$(find src -name '*.c' | sort)"
	if [ "$old" != "$new" ]; then
	  meson setup --reconfigure build
	  echo "$new" > build/stamps/src
	fi

	meson compile -v -C build

wipe: _wipe
	just run

_wipe:
	meson setup --wipe build
