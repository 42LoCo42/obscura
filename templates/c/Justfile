run: build
	./build/example

build:
	if [ ! -d build ] || [ ! -f build/meson-private/coredata.dat ]; then just _wipe; fi
	meson compile -C build

wipe: _wipe
	just run

_wipe:
	meson setup --wipe build
