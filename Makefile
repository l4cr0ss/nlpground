MOD = nlpground
obj-m += $(MOD).o

DBG_CFLAGS += -g -DDEBUG
ccflags-y += ${DBG_CFLAGS}
CC += ${DBG_CFLAGS}

KSRC ?= "/lib/modules/$(shell uname -r)/build"
PWD = $(shell pwd)

KVERSION = cd $(KSRC) && $(MAKE) kernelversion

.PHONY: all test clean debug
all: nlpground userlink

test:
	@echo "\n***NOTE: test only work if built for running kernel***\n"
	sudo dmesg -C
	sudo insmod $(MOD).ko
	sudo rmmod $(MOD).ko
	dmesg

clean:
	make -C $(KSRC) M=$(PWD) clean
	@rm -fr ./userlink ./_build

debug: 
debug:
	$(MAKE) -C $(KSRC) M=$(PWD) modules
	EXTRA_CFLAGS="$(DBG_CFLAGS)"

nlpground:
	$(MAKE) -C $(KSRC) M=$(PWD) modules
	@mkdir -p _build
	@mv .nlpground* modules.order nlpground.mod* nlpground.o Module.* ./_build

userlink: userlink.c
	gcc -g -o userlink $@.c
