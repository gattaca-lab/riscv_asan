#!/bin/bash

QEMU_BIN=/home/apink/google/env/tools/bin/qemu-system-riscv64

sudo ${QEMU_BIN} \
  -nographic \
  -machine virt \
  -kernel /home/apink/google/env/build/riscv_pk/bbl \
  -append "root=/dev/vda ro console=ttyS0" \
  -drive file=/home/apink/google/buildroot/output/images/rootfs.ext2,format=raw,id=hd0 \
  -device virtio-blk-device,drive=hd0 \
  -device virtio-net-device,netdev=net0,mac=00:e0:06:06:06:23 \
  -netdev tap,id=net0,script=/tmp/add_to_bridge.sh

