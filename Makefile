
all: rigdo.fw rigdo.zip
#all: usb_flash.img rigdo.fw

BRDIR=buildroot-2019.08.1

$(BRDIR).tar.gz:
	wget https://buildroot.org/downloads/$@ -O $@

$(BRDIR)/Makefile: $(BRDIR).tar.gz
	tar -xf $(BRDIR).tar.gz
	touch $@

$(BRDIR)/.config: $(BRDIR)/Makefile
	$(MAKE) BR2_EXTERNAL='../br2external_rigdo' -C $(BRDIR) rigdo_defconfig

$(BRDIR)/output/images/bzImage: $(BRDIR)/.config
	$(MAKE) -C $(BRDIR)

$(BRDIR)/output/images/rootfs.cpio.gz: $(BRDIR)/.config
	$(MAKE) -C $(BRDIR)

# needed /sbin/mkfs.vfat installed
usb_flash.img: $(BRDIR)/output/images/rootfs.cpio.gz
	dd if=/dev/zero bs=1M count=10 | cat - $(BRDIR)/output/images/bzImage $(BRDIR)/output/images/rootfs.cpio.gz > 2.dat #get needed size
	/sbin/mkfs.vfat -n RIGBOOT 2.dat
	$(BRDIR)/output/host/bin/mcopy -i 2.dat -s boot/syslinux.cfg $(BRDIR)/output/images/bzImage $(BRDIR)/output/images/rootfs.cpio.gz settings boot/uefi/EFI boot/uefi/loader/ ::
	syslinux 2.dat
	dd if=/dev/zero bs=512 count=2048 of=1.dat
	dd if=$(BRDIR)/output/images/syslinux/mbr.bin of=1.dat conv=notrunc
	$(BRDIR)/output/host/bin/genpart -t 0xc -c -b 2048 -s `du -B 512 2.dat | awk '{print $$1}'` | dd of=1.dat bs=1 seek=446 conv=notrunc
	echo -n -e '\x55\xaa'  | dd of=1.dat bs=1 seek=510 conv=notrunc
	cat 1.dat 2.dat > $@
	rm 1.dat 2.dat

fl=$(BRDIR)/output/images/bzImage $(BRDIR)/output/images/rootfs.cpio.gz start.sh sfx.stub
rigdo.fw: $(fl)
	rm -rf files
	mkdir -p files
	cp $(fl) files/
	tar -C files -czf files.tar.gz .
	rm -rf files
	cat sfx.stub files.tar.gz > $@
	chmod a+x $@

rigdo.zip: $(BRDIR)/output/images/rootfs.cpio.gz
	rm -rf rigdo
	mkdir -p rigdo
	cp $(BRDIR)/output/images/bzImage $(BRDIR)/output/images/rootfs.cpio.gz rigdo/
	cp -r boot/uefi/* rigdo/
	cp -r settings rigdo/
	rm -f $@
	cd rigdo && zip -r ../$@ *
	rm -rf rigdo


common=-m 4G -serial mon:stdio -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::8080-:80,hostfwd=tcp::8022-:22

run_img: usb_flash.img
	qemu-system-x86_64 $(common) -hda usb_flash.img -vnc :1

run: $(BRDIR)/output/images/rootfs.cpio.gz
	qemu-system-x86_64 $(common) -kernel $(BRDIR)/output/images/bzImage -initrd $(BRDIR)/output/images/rootfs.cpio.gz -append "options ro console=ttyS0" -nographic

rung: $(BRDIR)/output/images/rootfs.cpio.gz
	qemu-system-x86_64 $(common) -kernel $(BRDIR)/output/images/bzImage -initrd $(BRDIR)/output/images/rootfs.cpio.gz -append "options ro" -vnc :1

