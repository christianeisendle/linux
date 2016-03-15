#!/bin/bash
NUM_CPU_CORES=`/usr/bin/nproc`
KERNELRELEASE=`cat include/config/kernel.release`
CURRENT_KERNEL_VERSION=`uname -r`
CURRENT_KERNEL_SHORT_VERSION=`uname -r | sed -e "s/\([0-9]*.[0-9]*.[0-9]*\).*/\1/"`

if [ -e symvers/Module7.symvers.$CURRENT_KERNEL_SHORT_VERSION ]; then
	cp symvers/Module7.symvers.$CURRENT_KERNEL_SHORT_VERSION ./Module.symvers
else
	echo "Error: Module.symvers for current kernel ($CURRENT_KERNEL_SHORT_VERSION) not found. Check symvers/ folder for available versions or get the version for your kernel from https://github.com/raspberrypi/firmware/tree/master/extra"
	exit 1
fi
KERNEL=kernel7
make -j$NUM_CPU_CORES bcm2709_defconfig
make -j$NUM_CPU_CORES modules_prepare
make -j$NUM_CPU_CORES M=$PWD/drivers/bal && sudo make M=$PWD/drivers/bal modules_install

# copy also to current kernel dir
sudo mkdir -p /lib/modules/`uname -r`/extra/
sudo cp /lib/modules/$KERNELRELEASE/extra/bal.ko /lib/modules/$CURRENT_KERNEL_VERSION/extra/
sudo depmod -a

