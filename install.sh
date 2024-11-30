#!/bin/bash

set -ex

export efi="/dev/sda1"
export swap="/dev/sda2"
export arch="/dev/sda3"
export user="user"
export timezone="Europe/Paris"
export hostname="server"

timedatectl set-ntp true

mkfs.ext4 $arch -L "archlinux"
mount $arch /mnt

mkfs.fat -F 32 $efi -n EFI
mount --mkdir $efi /mnt/boot

mkswap $swap -L "swap"
swapon $swap

reflector \
    --verbose \
    --country France \
    --age 24 \
    --latest 16 \
    --sort rate \
    --save \
    /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab
