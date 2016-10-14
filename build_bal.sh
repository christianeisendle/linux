#!/bin/bash
NUM_CPU_CORES=`/usr/bin/nproc`


if [ "$1" = "raspi1" ]; then
    KERNEL=kernel
    DEFCONFIG=bcmrpi_defconfig
    MODULE_SYMVERS=Module.symvers
elif [ "$1" = "raspi2" ]; then
    KERNEL=kernel7
    DEFCONFIG=bcm2709_defconfig
    MODULE_SYMVERS=Module7.symvers
else
    echo "Usage: "
    echo "     To build for Raspberry Pi1:"
    echo -e
    echo "       $0 raspi1"
    echo -e
    echo "     To build for Raspberry Pi2/3:"
    echo -e
    echo "       $0 raspi2"
    echo -e
    exit 1
fi

make -j$NUM_CPU_CORES $DEFCONFIG
make -j$NUM_CPU_CORES modules_prepare

KERNELRELEASE=`cat include/config/kernel.release`
if [ -z "$CROSS_COMPILE" ]; then
    CURRENT_KERNEL_VERSION=`uname -r`
else
    CURRENT_KERNEL_VERSION=$KERNELRELEASE
fi
CURRENT_KERNEL_SHORT_VERSION=`echo $CURRENT_KERNEL_VERSION | sed -e "s/\([0-9]*.[0-9]*.[0-9]*\).*/\1/"`
if [ -e symvers/$MODULE_SYMVERS.$CURRENT_KERNEL_SHORT_VERSION ]; then
	cp symvers/$MODULE_SYMVERS.$CURRENT_KERNEL_SHORT_VERSION ./Module.symvers
else
	echo "Error: Module.symvers for current kernel ($CURRENT_KERNEL_SHORT_VERSION) not found. Check symvers/ folder for available versions or get the version for your kernel from https://github.com/raspberrypi/firmware/tree/master/extra"
	exit 1
fi
make -j$NUM_CPU_CORES M=$PWD/drivers/bal
if [ -z "$CROSS_COMPILE" ]; then
    sudo make M=$PWD/drivers/bal modules_install
    # copy also to current kernel dir
    sudo mkdir -p /lib/modules/$CURRENT_KERNEL_VERSION/extra/
    sudo cp /lib/modules/$KERNELRELEASE/extra/bal.ko /lib/modules/$CURRENT_KERNEL_VERSION/extra/
    sudo depmod -a
    make dtbs

    sudo cp arch/arm/boot/dts/overlays/bal.dtb* /boot/overlays
fi
