# Have a working RPi

- Download and dd Raspbian Lite (Debian Stretch) on a microSD card
- Plug the RPi with screen and keyboard (SSH is disabled by default)
- Log into RPi and set it up (sudo raspi-config: Expand Filesystem, enable SSH (Interfacing Options), downgrade GPU memory (Advanced Options, Memory Split, 16), update it (sudo rpi-update, sudo apt-get update, sudo apt-get upgrade, sudo apt-get dist-upgrade), whatever you want…)
- Reboot without screen and keyboard

From now on, use SSH to log into RPi.  We are using user `pi`.

## Log in RPi and install Docker

```shell
curl -sSL https://get.docker.com | sh ; sudo usermod -aG docker pi
```

## Logout + re-login (usermod taking effect)

## Mounting...

### If you're stuck with a ntfs external drive...

```shell
sudo apt-get install ntfs-3g
```

```shell
sudo blkid
/dev/sda1: LABEL="My Passport" UUID="3C02BB6502BB2336" TYPE="ntfs" PARTLABEL="My Passport" PARTUUID="3e1d9372-dada-4a7f-9542-ea32591373fd"
```

```shell
mkdir ~/.bitcoin
sudo mount -t ntfs-3g -o rw,uid=$(id -u bitcoinuser),gid=$(id -g pi),umask=007 /dev/sda1 ~/.bitcoin
```

```shell
sudo apt-get install git
```

### If you're stuck with a fat drive...

Adapt the docs and Dockerfiles so that Docker user root will be used.  Too bad for you.

## Extract this project on the machine

```shell
git clone https://github.com/SatoshiPortal/dockers.git
```
