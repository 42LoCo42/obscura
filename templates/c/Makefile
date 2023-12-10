NAME    := example
DEPS    :=
CFLAGS  := -Wall -Wextra -I glad/include
LDFLAGS :=

################################################################################

CFLAGS  += $(shell pkg-config --cflags $(DEPS))
LDFLAGS += $(shell pkg-config --libs   $(DEPS))

SRCS := $(shell find -name '*.c')
OBJS := $(patsubst %.c,build/%.o,$(SRCS))
DIRS := $(sort $(shell dirname $(OBJS)))

$(shell mkdir -p $(DIRS))

all: $(NAME)

build/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(NAME): $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@

run: $(NAME)
	./$<
.PHONY: run

install: $(NAME)
	mkdir -p $(out)/bin
	cp $< $(out)/bin
.PHONY: install

clean:
	rm -rf build $(NAME)
.PHONY: clean
