#!/bin/bash

# defaults
download_packages=true
copy_dotfiles=true
mount_drives=true

# update system before starting script
sudo pacman -Syu --noconfirm

# install package check
read -n1 -rep "Install extra packages? (Y/n)" inst
echo

if [[ $inst =~ ^[Nn]$ ]]; then
    download_packages=false
fi

if [[ $inst =~ ^[Yy]$ ]]; then
    download_packages=true
fi

# copy dotfiles check
read -n1 -rep "Install dotfiles (Y/n)" inst
echo

if [[ $inst =~ ^[Nn]$ ]]; then
    copy_dotfiles=false
fi

if [[ $inst =~ ^[Yy]$ ]]; then
    copy_dotfiles=true
fi

# mounting drives check
read -n1 -rep "Mount '/dev/nvme0n1p1'? (Y/n)" inst
echo

if [[ $inst =~ ^[Nn]$ ]]; then
    mount_drives=false
fi

if [[ $inst =~ ^[Yy]$ ]]; then
    mount_drives=true
fi

# install core packages
sudo pacman -S --noconfirm - < core

# paru/yay check | install extra packages
if $download_packages; then
    if command -v paru &> /dev/null; then
     aur_helper="paru"
    elif command -v yay &> /dev/null; then
     aur_helper="yay"
    else
     git clone https://aur.archlinux.org/paru.git
     cd paru && makepkg -si --noconfirm && cd .. && rm -rf paru && aur_helper="paru"
    fi
    $aur_helper -S --noconfirm - < packages

# dotfiles install script
if $copy_dotfiles; then
    cp -r dotfiles/home/retard /home

# drive mount script
if $mount_drives; then
    sudo mkdir -p /media/Dryden
    sudo printf "\n\n# /dev/nvme0n1p1 (Dryden)\n/dev/nvme0n1p1 /media/Dryden ext4 defaults 0 0" | sudo tee -a /etc/fstab 
    sudo mount -a

# enables 'color' and 'ilovecandy' in pacman.conf
sudo sed -i -e 's/#Color/Color\nILoveCandy/g' /etc/pacman.conf

# inverts paru's list
sudo sed -i -e 's/#BottomUp/BottomUp/g' /etc/paru.conf
