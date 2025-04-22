#!/bin/bash

# Create structure
mkdir -p /iso-root/live /iso-root/isolinux

# Copy files
cp /build-output/filesystem.squashfs /iso-root/live/
cp /mnt/unsquashfs/boot/vmlinuz-* /iso-root/live/vmlinuz
cp /mnt/unsquashfs/boot/initrd.img-* /iso-root/live/initrd

# Copy bootloader
cp /usr/lib/ISOLINUX/isolinux.bin /iso-root/isolinux/
cp /usr/lib/syslinux/modules/bios/menu.c32 /iso-root/isolinux/

# Create config
cat <<EOF > /iso-root/isolinux/isolinux.cfg
UI menu.c32
PROMPT 0
TIMEOUT 30
DEFAULT live

LABEL live
  MENU LABEL Live Debian (Custom)
  KERNEL /live/vmlinuz
  APPEND initrd=/live/initrd boot=live components quiet splash
EOF

# Build ISO
xorriso -as mkisofs \
  -o /root/custom-debian.iso \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -c isolinux/boot.cat \
  -b isolinux/isolinux.bin \
     -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot \
  -iso-level 3 -J -R -V "CustomDebian" \
  /iso-root
