#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
mkdir -p $SCRIPT_DIR/tmp

echo "Install dependencies"
sudo pacman -Sy archlinux-keyring --noconfirm --needed
sudo pacman -Sy acpica --noconfirm --needed

echo "Compile fix"
cd $SCRIPT_DIR/tmp || exit 1
cp $SCRIPT_DIR/resources/ssdt_wifi_fix.asl $SCRIPT_DIR/tmp/ssdt_wifi_fix.asl
iasl -tc ssdt_wifi_fix.asl

echo "Move fix to /boot"
sudo mv $SCRIPT_DIR/tmp/ssdt_wifi_fix.asl /boot/ssdt_wifi_fix.asl

echo "Copy acpi load script to /etc/grub.d"
sudo cp $SCRIPT_DIR/resources/01_acpi /etc/grub.d/01_acpi

echo "Update grub"
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Deleting tmp files"
rm -rf $SCRIPT_DIR/tmp

echo "Wi-Fi wakeup fix completed"
