# rigdo
Build bootable usb flash for mining
Based on buildroot: https://buildroot.org/

## Buildroot dependencies: 
  https://git.buildroot.net/buildroot/tree/docs/manual/prerequisite.txt : requirement-mandatory

## Build:
```
git clone https://github.com/rigdo/rigdo.git
cd rigdo
make
```
## Install
### UEFI supported in BIOS (modern comps)
1 Download the latest version of "rigdo" https://github.com/rigdo/usb-flash-uefi/releases/latest  (rigdo_v0.xxx.zip, ~130 MB)
2 Unzip to USB flash (FAT32)
3 Change stick name to RIGBOOT
4 Download your rig with a stick
#### Video:
https://youtu.be/PTh6mTiKNck

### UEFI not supported in BIOS(old comps)
Prebuilded image for old comp without uefi: https://webgen.rigdo.com:webgen/usb_flash.img
```
sudo dd if=usb_flash.img of=/dev/sdX bs=1M
```
