#!/bin/bash

ROOT_DIR="env"
SRC_DIR="$(pwd)"
TOOLS_DIR="${ROOT_DIR}/tools"
BUILD_DIR="${ROOT_DIR}/build"
BUILD_GCC_RV64GC="${BUILD_DIR}/gcc_rv64gc"
BUILD_GCC_RV64IMAC="${BUILD_DIR}/gcc_rv64imac"
BUILD_QEMU="${BUILD_DIR}/qemu"
BUILD_PK="${BUILD_DIR}/riscv-pk"
mkdir -p ${BUILD_QEMU}
mkdir -p ${BUILD_GCC_RV64GC}
mkdir -p ${BUILD_GCC_RV64IMAC}
mkdir -p ${BUILD_PK}

echo "building qemu..."
cd ${SRC_DIR}/qemu
git checkout stable-4.1
git submodule update
cd ${BUILD_QEMU}
${SRC_DIR}/qemu/configure --prefix=${TOOLS_DIR} --target-list=riscv64-softmmu
make -j20
make install

echo "building gcc for RV64IMAC"
cd "${BUILD_GCC_RV64IMAC}"
${SRC_DIR}/riscv-gnu-toolchain/configure --prefix=${TOOLS_DIR} --with-arch=rv64imac
make linux -j20 # `make linux` means that we are building "Linux" toolchain

echo "building gcc for RV64GC"
cd "${BUILD_GCC_RV64GC}"
${SRC_DIR}/riscv-gnu-toolchain/configure --prefix=${TOOLS_DIR} --with-arch=rv64gc
make linux -j20 # `make linux` means that we are building "Linux" toolchain


echo "building Linux"
cd "${SRC_DIR}/linux"
git checkout gattaca_riscv_hwasan
cp riscv.config .config
ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- make menuconfig
ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- make vmlinux -j20

echo "building riscv-pk"
cd ${BUILD_PK}
PATH="${TOOLS_DIR}/gcc_rv64imac/bin:$PATH" \
  ./configure --enable-log  --host=riscv64-unknown-linux-gnu --with-payload=${SRC_DIR}/linux/vmlinux
make -j20
#NOTE: --enable-log <--enable-logo

#- git clone git://git.busybox.net/buildroot
#- cd buildroot
#- make qemu_riscv64_virt_defconfig
#- make menuconfig
#- Target options -> Target architecture -> custom; Enable everything except float
#- Target options -> Target ABI -> lp64
#- Toolchain -> Toolchain type -> External toolchain
#- Toolchain -> Toolchain path -> <rv64imac install path>
#- Toolchain -> Toolchain prefix -> riscv64-unknown-linux-gnu
#- Toolchain -> External toolchain kernel headers -> 5.0.x
#- Toolchain -> External toolchain C library -> glibc
#- Toolchain -> HasSSP support
#- Toolchain -> HasRPC support
#- Toolchain -> HasC++ support
#- Kernel -> Disable Linux Kernel
#- Target packages -> Filesystem and flash utilities -> nfs-utils, enable all
#- Target packages -> Debugging, profiling and benchmark -> strace
#- Target packages -> BusyBox -> enable Show packages that are also provided by busybox
#- Target packages -> Shell and utilities -> {bash,tmux,file}
#- System configuration -> set bash as default shell
#- make -j10

#- git clone https://gitea.yggdrasill.ga/Gattaca/llvm-project
#- cd llvm-project && mkdir build && cd build
#- PATH=$PATH=<rv64imac toolchain install path>/bin/
#- cmake -G Ninja -DLLVM_USE_LINKER="gold" -DCMAKE_BUILD_TYPE="Debug" -DLLVM_ENABLE_PROJECTS="clang" -DCMAKE_CROSSCOMPILING=True -DCMAKE_INSTALL_PREFIX=<cross-llvm install path> -DLLVM_ENABLE_ASSERTIONS=On -DLLVM_TARGETS_TO_BUILD="RISCV" -DLLVM_TARGET_ARCH="riscv64" -DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-linux-gnu" -DDEFAULT_SYSROOT="\<riscv64imac toolchain path\>sysroot/" -DGCC_INSTALL_PREFIX="\<riscv64imac toolchain path\>" ../llvm
#- ninja
#- ninja install
#- <cross-llvm install path>/bin/clang <c source> -L <rv64imac toolchain path>/lib/gcc/riscv64-unknown-linux-gnu/9.2.0/ -B <rv64imac toolchain path>/lib/gcc/riscv64-unknown-linux-gnu/9.2.0/
#- Run linux
