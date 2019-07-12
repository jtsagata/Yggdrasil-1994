#!/bin/bash


echo "Checking if  qemu-system-x86 is installed"
if ! which qemu-system-i386 > /dev/null; then
    echo "Not installed. Enter root password"
    sudo apt-get install qemu-system-x86
    sudo apt-get install qemu-utils
    sudo adduser `id -un` kvm
    echo "logout and login if kvm errors"
fi   

echo "Create disk image"
DISK_IMG=Yggdrasil-1994_flat.dd
if [ -f ${DISK_IMG} ]; then
    echo "${DISK_IMG} file exist";
else 
    dd if=/dev/zero bs=1024 count=30M of=${DISK_IMG} status=progress
fi



echo "Checking if KVM is supported"
if ! which kvm-ok > /dev/null; then
    echo "Not installed. Enter root password"
    sudo apt-get install cpu-checker
fi   
kvm-ok

echo "To ungrab mouse use Ctrl+Alt+G"
echo "ente linux no-hlt to boot"
sudo qemu-system-i386 -enable-kvm -M pc-1.0 -cpu 486 -m 64 \
   -drive file=${DISK_IMG},if=ide,format=raw \
   -drive file=ygdrasil.iso,if=ide,index=1,media=cdrom \
   -fda bootflpy.3in \
   -boot order=cad -no-reboot \
   -name yggdrasil-1994 -sdl -k en-us

