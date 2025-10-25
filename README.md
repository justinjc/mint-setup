# Mint Setup

Runbook:
* Check for Update Manager updates
* Check for Driver Manager updates
* Install scripts:
```
sudo apt update
sudo apt install git
git clone https://github.com/justinjc/mint-setup.git
./mint-setup/install.sh
```
* Generate ssh key: `ssh-keygen -t ed25519 -C "justin@justinjc.com"`
* Add SSH key to GitHub: https://github.com/settings/keys
* Choose a desktop theme: `lxappearance`
* Customize GRUB: `grub-customizer`
* Register Sublime Text 3 license key
* Log out and choose i3 as the window manager to log back in
