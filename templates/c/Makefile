DEPS    :=
CFLAGS  := $(shell pkg-config --cflags $(DEPS)) -Wall -Wextra
LDFLAGS := $(shell pkg-config --libs   $(DEPS))

all: main

run: main
	./$<
.PHONY: run
