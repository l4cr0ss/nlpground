MOD = nlpground
obj-m += $(MOD).o

KSRC ?= "/lib/modules/$(shell uname -r)/build"
PWD = $(shell pwd)

KVERSION = cd $(KSRC) && $(MAKE) kernelversion

.PHONY: all test clean
all: nlpground userlink

test:
	@echo "\n***NOTE: test only work if built for running kernel***\n"
	sudo dmesg -C
	sudo insmod $(MOD).ko
	sudo rmmod $(MOD).ko
	dmesg

clean:
	make -C $(KSRC) M=$(PWD) clean
	@rm -fr ./userlink ./build

nlpground:
	$(MAKE) -C $(KSRC) M=$(PWD) modules
	@mkdir -p build
	@mv .nlpground* modules.order nlpground.mod* nlpground.o Module.* ./build

userlink:
	gcc -g -o userlink userlink.c
