#!/bin/bash

# Default settings
DOWNLOAD_PACKAGES=true
COPY_DOTFILES=true
MOUNT_DRIVES=true

# Function to prompt user for confirmation
prompt_user() {
    read -n1 -rep "$1 (Y/n)" response
    echo
    case $response in
        [Nn]) return 1 ;;
        *) return 0 ;;
    esac
}

# Update system before starting script
sudo pacman -Syu --noconfirm

# Ask user if they want to install extra packages
prompt_user "Install extra packages?" && DOWNLOAD_PACKAGES=true || DOWNLOAD_PACKAGES=false

# Ask user if they want to copy dotfiles
prompt_user "Copy dotfiles?" && COPY_DOTFILES=true || COPY_DOTFILES=false

# Ask user if they want to mount drives
prompt_user "Mount '/dev/nvme0n1p1'?" && MOUNT_DRIVES=true || MOUNT_DRIVES=false

# Install core packages
sudo pacman -S --noconfirm - < core

# Install extra packages using AUR helper
if $DOWNLOAD_PACKAGES; then
    if command -v paru &> /dev/null; then
        aur_helper="paru"
    elif command -v yay &> /dev/null; then
        aur_helper="yay"
    else
        git clone https://aur.archlinux.org/paru.git
        cd paru && makepkg -si --noconfirm && cd .. && rm -rf paru
        aur_helper="paru"
    fi
    $aur_helper -S --noconfirm - < packages
fi

# Copy dotfiles to home directory
if $COPY_DOTFILES; then
    cp -r dotfiles/home/retard /home
fi

# Mount drive and update fstab
if $MOUNT_DRIVES; then
    sudo mkdir -p /media/Dryden
    echo -e "\n\n# /dev/nvme0n1p1 (Dryden)\n/dev/nvme0n1p1 /media/Dryden ext4 defaults 0 0" | sudo tee -a /etc/fstab
    sudo mount -a
fi

# Enable 'Color' and 'ILoveCandy' in pacman.conf
sudo sed -i 's/#Color/Color\nILoveCandy/g' /etc/pacman.conf

# Enable 'BottomUp' in paru.conf
sudo sed -i 's/#BottomUp/BottomUp/g' /etc/paru.conf
