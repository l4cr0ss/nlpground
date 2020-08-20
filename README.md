# Netlink Playground

## What

A kernel module + userspace driver to explore the Linux kernel's netlink API.

Based on: https://stackoverflow.com/a/3334782/1666488

## Why 

For fun and profit.

## How

1. Clone the repo.

`git clone https://github.com/l4cr0ss/nlpground.git`

2. Export location of kernel source tree as `KSRC`.

`export KSRC="/opt/ubuntu-build/ubuntu-focal"`

3. Run `make`.

```
l4@l4-5580:~/research/netlink$ make
make -C "/opt/ubuntu-build/ubuntu-focal" M=/home/l4/research/netlink modules
make[1]: Entering directory '/opt/ubuntu-build/ubuntu-focal'
  CC [M]  /home/l4/research/netlink/nlpground.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC [M]  /home/l4/research/netlink/nlpground.mod.o
  LD [M]  /home/l4/research/netlink/nlpground.ko
make[1]: Leaving directory '/opt/ubuntu-build/ubuntu-focal'
gcc -g -o userlink userlink.c
```

4. Copy kernel module (`.ko`) and `userlink` program to your test env

5. Insert kernel module

```
root@syzkaller:~# insmod nlpground.ko 
[   26.707903] nlpground: loading out-of-tree module taints kernel.
[   26.709125] nlpground: module verification failed: signature and/or required key missing - tainting kernel
[   26.717010] Entering: nlpground_init
```

6. Run userspace driver

```
root@syzkaller:~# ./userlink
Sending message to kernel
[   28.822159] Entering: nlpground_nl_recv_msg
[   28.822654] Netlink received msg payload:Hello
Waiting for message from kernel
Received message payload: Hello from kernel
```
