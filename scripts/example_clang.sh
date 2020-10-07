#!/bin/bash

cmake \
  -DLLVM_USE_LINKER="gold" \
  -DCMAKE_BUILD_TYPE="Debug" \
  -DLLVM_ENABLE_PROJECTS="clang" \
  -DCMAKE_CROSSCOMPILING=True \
  -DCMAKE_INSTALL_PREFIX=/home/apink/google/env/tools \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_TARGETS_TO_BUILD="RISCV" \
  -DLLVM_TARGET_ARCH="riscv64" \
  -DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-linux-gnu" \
  -DDEFAULT_SYSROOT=/home/apink/google/env/tools/gcc_rv64imac/sysroot \
  -DGCC_INSTALL_PREFIX=/home/apink/google/env/tools/gcc_rv64imac \
  /home/apink/google/llvm-project
