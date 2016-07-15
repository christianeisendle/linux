# NXP NFCRdlib Kernel BAL Module for Raspberry pi

## General
This is an out-of-the-box working example of nxprdlib-kernel-bal project for raspberry pi 1/2/3. 
For more information on nxprdlib-kernel-bal refer to https://github.com/christianeisendle/nxprdlib-kernel-bal

## How to build
- Add missing dependencies: `sudo apt-get install bc`
- Clone the project including the bal submodule: `git clone https://github.com/christianeisendle/linux --depth=1 --recursive`
- Build the module using the included build script: `./build_bal.sh raspi1` for raspberry pi1, `./build_bal.sh raspi2` for raspberry pi 2 or 3
- Reboot and load the module using `modprobe bal`
