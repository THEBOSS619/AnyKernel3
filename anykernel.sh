# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=RZ Kernel for Exynos 9810 devices
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=starlte
device.name2=starltexx
device.name3=star2lte
device.name4=star2ltexx
device.name5=crownlte
device.name6=crownltexx
supported.versions=10
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/11120000.ufs/by-name/BOOT;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;


## AnyKernel install
dump_boot;

ui_print "Remounting /vendor";
mount -o remount,rw /vendor;

if [ ! -e /vendor/etc/fstab.samsungexynos9810~ ]; then
	ui_print "Backing up vendor fstab";
	backup_file /vendor/etc/fstab.samsungexynos9810;
fi;

ui_print "Patching vendor fstab";
patch_fstab /vendor/etc/fstab.samsungexynos9810 /data ext4 flags "forceencrypt=footer" "encryptable=footer";

ui_print "Copying vendor script";
cp -f $home/vendor/etc/init/init.services.rc /vendor/etc/init;

mv -f $home/dtb.img $split_img/extra;

write_boot;
## end install

