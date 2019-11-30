#!/bin/sh

exit_on_error()
{
	if [ $? = 0 ]
	then
		return
	fi
	text=$1
	echo "$text, exit"
	exit 1
}

updateabspath=$1
skip=$2

tail -n +${skip} ${updateabspath} | tar -xz ./bzImage
exit_on_error "cant extract ./bzImage"
tail -n +${skip} ${updateabspath} | tar -xz ./rootfs.cpio.gz
exit_on_error "cant extract ./rootfs.ext2.gz"

mount -o remount LABEL=RIGBOOT /mnt/store
exit_on_error "cant remount nosync /mnt/store"

cp ./bzImage /mnt/store
cp ./rootfs.cpio.gz /mnt/store
sync

mount -o remount,sync LABEL=RIGBOOT /mnt/store

sync
sync

echo "SUCCESS: Done."

