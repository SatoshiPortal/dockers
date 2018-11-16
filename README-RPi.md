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
