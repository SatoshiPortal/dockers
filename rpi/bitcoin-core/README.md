
# How to install a Bitcoin Core full node on a RPi using Docker

## Nota

Don't just copy and paste.  Understand what you are doing.

## Assumptions

[You have a working RPi.](https://github.com/SatoshiPortal/docker/tree/master/rpi)

## Log in RPi (user pi in this document), create bitcoinuser


```shell
sudo useradd bitcoinuser
```

## (if not using existing files): Create bitcoin working directory

```shell
mkdir ~/.bitcoin
```

## Apply permissions to bitcoin working directory

```shell
sudo chown -R bitcoinuser:pi ~/.bitcoin ; sudo chmod g+ws ~/.bitcoin
```

## (if using existing files): Recursively apply permissions to existing files

```shell
sudo find ~/.bitcoin -type d -exec chmod 2775 {} \; ; sudo find ~/.bitcoin -type f -exec chmod g+rw {} \;
```

## Create bitcoin.conf in ~/.bitcoin/ with following content:
(replacing `rpcusername`, `rpcpassword`, `10.0.0.0/24` and others by your actual values)

```properties
testnet=1
txindex=1
rpcuser=rpcusername
rpcpassword=rpcpassword
rpcallowip=10.0.0.0/24
printtoconsole=1
maxmempool=64
dbcache=64
zmqpubrawblock=tcp://0.0.0.0:29000
zmqpubrawtx=tcp://0.0.0.0:29000
```

## Build docker image
(replacing Bitcoin Core version by the one you want)

```shell
docker build -t btcnode --build-arg USER_ID=$(id -u bitcoinuser) --build-arg GROUP_ID=$(id -g bitcoinuser) --build-arg CORE_VERSION="0.16.0" .
```

## Get docker image ID

```shell
docker images
```

## Run docker container
(replacing `SP-BTC01` by the container name you want)

```shell
docker run -d --rm --mount type=bind,source="$HOME/.bitcoin",target="/bitcoin/.bitcoin" --name SP-BTC01 -p 18333:18333 -p 18332:18332 -p 29000:29000 btcnode
```

```shell
docker run -d --rm --mount type=bind,source="$HOME/.bitcoin",target="/bitcoin/.bitcoin" --name SP-BTC01 -p 18333:18333 -p 18332:18332 -p 29000:29000 btcnode bitcoin ./bitcoin-cli getinfo
```

## If needed, re-apply permissions to newly created files

```shell
sudo find ~/.bitcoin -type d -exec chmod 2775 {} \; ; sudo find ~/.bitcoin -type f -exec chmod g+rw {} \;
```

## Show logs or info

With `printtoconsole=1` in bitcoin.conf:

```shell
docker logs -f SP-BTC01
```

Without `printtoconsole=1` in bitcoin.conf:

```shell
sudo tail -f ~/.bitcoin/testnet3/debug.log
```

Invoking bitcoin-cli…

```shell
docker exec -it SP-BTC01 ./bitcoin-cli getblockchaininfo
```

---

# Installing and using LVM to combine several storage devices into one big volume

A full archival (transactions indexed) Mainnet Bitcoin node needs a lot of disk space.  I have a bunch of old USB flash drives… I’d like to combine them all in one big disk and use that virtual disk for my node.  Sounds like a fun hacky step!

## Install lvm2 (Logical Volume Manager)

```shell
sudo apt-get install lvm2
```

## Get USB device IDs:

```shell
sudo blkid
```

## Create physical volumes for those devices

```shell
sudo pvcreate /dev/sda1
sudo pvcreate /dev/sdb1
sudo pvs
```

## Create a virtual group and put physical volumes in it

```shell
sudo vgcreate btcVG /dev/sda1
sudo vgextend btcVG /dev/sdb1
sudo vgdisplay
```

## Create logical volume within the group, using all space, and format it

```shell
sudo lvcreate -n btcLV -l 100%FREE btcVG
sudo mkfs -t ext4 /dev/mapper/btcVG-btcLV
```

## If uncleanly unmounted (“can't read superblock” message on mount), try

```shell
sudo fsck /dev/btcVG/btcLV
```

## Mount new volume for our .bitcoin directory

```shell
sudo mount /dev/btcVG/btcLV ~/.bitcoin
sudo lvdisplay
```

## Adding the mounting instruction in fstab is a good idea

```shell
echo '/dev/btcVG/btcLV /home/pi/.bitcoin' | sudo tee --append /etc/fstab > /dev/null
```
