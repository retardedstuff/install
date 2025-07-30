#!/bin/bash

# installs paru + packages
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si --noconfirm && cd .. && rm -rf paru
paru -S --noconfirm - < packages

# copy dotfiles
cp -r dotfiles/home/retard /home/retard

# mount drives
sudo mkdir -p /media/Dryden
sudo printf "\n\n# /dev/nvme0n1p1 (Dryden)\n/dev/nvme0n1p1 /media/Dryden ext4 defaults 0 0" | sudo tee -a /etc/fstab 
sudo mount -a

# enables 'color' and 'ilovecandy' in pacman.conf
sudo sed -i -e 's/#Color/Color\nILoveCandy/g' /etc/pacman.conf

# inverts paru's list
sudo sed -i -e 's/#BottomUp/BottomUp/g' /etc/paru.conf
