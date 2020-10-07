# RISCV ASAN

This reporistory is the root of riscv-asanproject. It contains
guidelines, documentation and includes all relevant repositories as a
submodules.

The main purpose is to provide instructions regarding the general development
process and to provide releases.

## How to obtain sources

* git clone https://github.com/gattaca-lab/riscv_asan
* cd riscv_asan
* ./setup_git

## How to build everything

To build Linux/QEMU/Buildroot/Cross-toolchains:

```
CPU_NUM=<n> ./build.sh target all

To build native LLVM toolchain:

```
CPU_NUM=<n> ./build.sh native
```

## How to compile with clang and ASAN

Example of compilation string:

```
  ./install/bin/clang \<c source\> -fsanitize=address
```

## How to run QEMU vm

* **NB**: existing network configuration is tailored for neptune machine only
* Modify run_qemu script and configure network for your system:
```
./run_qemu.sh
# For neptune users: once you are logged in - use the following command
mount.nfs neptune:/tank/work/dev/share/nfs/ /mnt/
```

## How to modify rootfs image
* In **src/config/riscv** there are different directories that are copied into the built rootfs image
* If you want to modify anything inside your image, put a modified file into proper directory and it would be copied
