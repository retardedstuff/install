#!/bin/bash

# installs paru + packages
pacman -Syu --noconfirm
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si --noconfirm && cd .. && rm -rf paru
paru --noconfirm - < packages

# copy dotfiles
cp dotfiles/home/retard/.config ~/.config

# mount drives
mkdir -p /media/Dryden
printf "\n\n# /dev/nvme0n1p1 (Dryden)\n/dev/nvme0n1p1 /media/Dryden ext4 defaults 0 0" >> /etc/fstab
mount -a

# enables 'color' and 'ilovecandy' in pacman.conf
sed -i -e 's/#Color/Color\nILoveCandy/g' /etc/pacman.conf

# inverts paru's list
sed -i -e 's/#BottomUp/BottomUp/g' /etc/paru.conf