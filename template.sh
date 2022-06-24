TEMPLATE=./tools/template
[ -e $TEMPLATE ] || rm $TEMPLATE 
unmkinitramfs /boot/initrd.img-$(uname -r) $TEMPLATE
[ ! -e $TEMPLATE/early ] || rm -rf $TEMPLATE/early   
[ ! -e $TEMPLATE/early2 ] || rm -rf $TEMPLATE/early2
mv $TEMPLATE/main/* $TEMPLATE/
rm -rf $TEMPLATE/main

