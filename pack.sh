. ./tools/config
find . -path ./tools -prune -o -print | cpio -o -H newc | gzip > $INITRD
