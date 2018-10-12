
# How to install a Bitcoin Core full node on a x86_64 machine using Docker

## Nota

Don't just copy and paste.  Understand what you are doing.

Note: We can't change ownership of files if directory is mounted from a vfat filesystem.  You will have to use root user instead of bitcoinuser or set all files in .bitcoin directory to world-writable.

## Log in (user debian:debian in this document), create bitcoinuser

```shell
sudo useradd bitcoinuser
```

## Mounting... if you want to use an external drive/stick for the blockchain

### If you're stuck with a ntfs external drive...

```shell
sudo apt-get install ntfs-3g
```

```shell
sudo blkid
/dev/sda1: LABEL="My Passport" UUID="3C02BB6502BB2336" TYPE="ntfs" PARTLABEL="My Passport" PARTUUID="3e1d9372-dada-4a7f-9542-ea32591373fd"
```

```shell
mkdir -m 2770 -p ~/btcdata
sudo mount -t ntfs-3g -o rw,uid=$(id -u bitcoinuser),gid=$(id -g debian),umask=007 /dev/sda1 ~/btcdata
```

### If you're stuck with a fat drive...

Adapt the docs and Dockerfiles so that Docker user root will be used.  Too bad for you.

## (if not using existing files): Create bitcoin working directory

```shell
mkdir -m 2770 -p ~/btcdata
```

## Apply permissions to bitcoin working directory
(this cannot be done on a vfat mounted filesystem)

```shell
sudo chown -R bitcoinuser:debian ~/btcdata
```

## (if using existing files): Recursively apply permissions to existing files
(this cannot be done on a vfat mounted filesystem)

```shell
sudo find ~/btcdata -type f -exec chmod g+rw {} \; ; sudo find ~/btcdata -type d -exec chmod g+rwx {} \;
```

## Create bitcoin.conf in ~/btcdata/ with following content:
(replacing `rpcusername`, `rpcpassword`, `10.0.0.0/24` and others by your actual values)

```properties
testnet=1
txindex=1
rpcuser=rpcusername
rpcpassword=rpcpassword
rpcallowip=10.0.0.0/24
#printtoconsole=1
maxmempool=64
dbcache=64
zmqpubrawblock=tcp://0.0.0.0:29000
zmqpubrawtx=tcp://0.0.0.0:29000
```

## Build docker image
(replacing Bitcoin Core version by the one you want)

```shell
docker build -t btcnode .
```

## Run docker container

```shell
docker run --rm -d --name btcnode -p 18333:18333 -p 18332:18332 -p 29000:29000 -v /home/pi/btcdata:/.bitcoin btcnode `id -u bitcoinuser`:`id -g bitcoinuser` bitcoind
```

## If needed, re-apply permissions to newly created files

```shell
sudo find ~/btcdata -type f -exec chmod g+rw {} \; ; sudo find ~/btcdata -type d -exec chmod g+rwx {} \;
```

## Show logs or info

With `printtoconsole=1` in bitcoin.conf:

```shell
docker logs -f btcnode
```

Without `printtoconsole=1` in bitcoin.conf:

```shell
sudo tail -f ~/btcdata/testnet3/debug.log
```

Invoking bitcoin-cli…

```shell
docker exec -it btcnode bitcoin-cli -datadir=/.bitcoin stop
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
sudo mount /dev/btcVG/btcLV ~/btcdata
sudo lvdisplay
```

## Adding the mounting instruction in fstab is a good idea

```shell
echo '/dev/btcVG/btcLV /home/debian/btcdata' | sudo tee --append /etc/fstab > /dev/null
```

## Adding more space (because the blockchain increases over time)...

```shell
sudo pvcreate /dev/sdc1
sudo vgextend btcVG /dev/sdc1
sudo lvextend /dev/btcVG/btcLV /dev/sdc1
sudo e2fsck -f /dev/btcVG/btcLV
sudo resize2fs /dev/btcVG/btcLV
```
