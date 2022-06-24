. ./tools/config
sudo kvm -kernel $KERNEL \
 -cpu host \
 -initrd $INITRD \
 -display curses \
 -m 1G \
 -drive file=/dev/gpl-hd,format=raw
 