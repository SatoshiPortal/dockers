# OTS setup on x86

## Bitcoin Node

### Attach Lunanode volume to instance
(using a volume makes it easy to backup or retrieve data if something happens to VM)

...in the Lunanode control panel

### Format the volumes
(one for OTS data, the other for the pruned Bitcoin node)

```shell
debian@ots01:~$ sudo mkfs.ext4 /dev/vdc
mke2fs 1.43.4 (31-Jan-2017)
Creating filesystem with 13107200 4k blocks and 3276800 inodes
Filesystem UUID: d2af1fd1-8b72-4702-84c7-83739500ecf9
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
	4096000, 7962624, 11239424

Allocating group tables: done
Writing inode tables: done
Creating journal (65536 blocks): done
Writing superblocks and filesystem accounting information: done
```

```shell
debian@ots01:~$ sudo mkfs.ext4 /dev/vdd
mke2fs 1.43.4 (31-Jan-2017)
Creating filesystem with 4194304 4k blocks and 1048576 inodes
Filesystem UUID: dac2c051-b53c-432d-bf75-79ed8c11e1fc
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
	4096000

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done   
```

### Set volumes and directories...

```shell
mkdir ~/.bitcoin
sudo mount /dev/vdc ~/.bitcoin/
mkdir ~/otsd
sudo mount /dev/vdd ~/otsd/
```

### Install server packages: git and docker

#### GIT

```shell
sudo apt-get update ; sudo apt-get upgrade ; sudo apt-get install git
```

#### DOCKER installation

See Docker's web site for insllation instructions: https://docs.docker.com/install/linux/docker-ce/debian/

#### Create Docker Swarm and overlay network used by our containers

```shell
docker swarm init --task-history-limit 1
docker network create --driver=overlay --attachable --opt encrypted spbtcnodenet
```

#### Our Bitcoin Node Container

```shell
sudo useradd bitcoinuser
sudo chown -R bitcoinuser:debian ~/.bitcoin ; sudo chmod g+ws ~/.bitcoin
sudo find ~/.bitcoin -type d -exec chmod 2775 {} \; ; sudo find ~/.bitcoin -type f -exec chmod g+rw {} \;
vi ~/.bitcoin/bitcoin.conf
```
```console
prune=550
rpcuser=username
rpcpassword=password
rpcallowip=10.0.0.0/24
maxmempool=64
dbcache=64
rpcconnect=btcnode-ots
```
```shell
git clone https://github.com/SatoshiPortal/dockers.git
vi dockers/x86_64/bitcoin-core/Dockerfile
docker build -t btcnode --build-arg USER_ID=$(id -u bitcoinuser) --build-arg GROUP_ID=$(id -g bitcoinuser) --build-arg CORE_VERSION="0.16.2" dockers/x86_64/bitcoin-core/.
docker run -d --rm --mount type=bind,source="$HOME/.bitcoin",target="/bitcoin/.bitcoin" --name btcnode-ots --network spbtcnodenet btcnode
```

## Our nginx instance
(Setting up web server + SSL certificates from Let's Encrypt)

```shell
docker run -d -p 80:80 -p 443:443 --name nginx -v /home/debian/otsd/nginx/certs:/etc/nginx/certs:ro -v /etc/nginx/conf.d -v /etc/nginx/vhost.d -v /usr/share/nginx/html --network spbtcnodenet nginx:alpine
```

## Our nginx-gen instance

```shell
sudo chown -R debian:debian ~/otsd/nginx
curl https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl > ~/otsd/nginx/nginx.tmpl

docker run -d --name nginx-gen --volumes-from nginx -v /home/debian/otsd/nginx/nginx.tmpl:/etc/docker-gen/templates/nginx.tmpl:ro -v /var/run/docker.sock:/tmp/docker.sock:ro --network spbtcnodenet jwilder/docker-gen -notify-sighup nginx -watch -wait 5s:30s /etc/docker-gen/templates/nginx.tmpl /etc/nginx/conf.d/default.conf
```

## Our Let's Encrypt companion!

```shell
docker run -d --name nginx-letsencrypt --volumes-from nginx -v /home/debian/otsd/nginx/certs:/etc/nginx/certs:rw -v /var/run/docker.sock:/var/run/docker.sock:ro --network spbtcnodenet -e NGINX_DOCKER_GEN_CONTAINER=nginx-gen -e NGINX_PROXY_CONTAINER=nginx jrcs/letsencrypt-nginx-proxy-companion
```

## Our OTS Node Container

### First time only

```shell
mkdir -p ~/otsd/otsserver01/calendar/
echo "https://btc.calendar.otsserver01.com/" > ~/otsd/otsserver01/calendar/uri
dd if=/dev/random of=~/otsd/otsserver01/calendar/hmac-key bs=32 count=1
sudo useradd otsuser
```

#### Only if you want more than one OTS server on the machine...

```shell
mkdir -p ~/otsd/otsserver02/calendar/
echo "https://btc.calendar.otsserver02.com/" > ~/otsd/otsserver02/calendar/uri
dd if=/dev/random of=~/otsd/otsserver02/calendar/hmac-key bs=32 count=1
```

#### Set OTS server image and directory access

```shell
sudo chown -R otsuser:debian ~/otsd ; sudo chmod g+ws ~/otsd
sudo find ~/otsd -type d -exec chmod 2775 {} \; ; sudo find ~/otsd -type f -exec chmod g+rw {} \;
git clone https://github.com/SatoshiPortal/dockers.git
vi dockers/x86_64/ots/otsserver/Dockerfile
docker build -t otsserver --build-arg USER_ID=$(id -u otsuser) --build-arg GROUP_ID=$(id -g otsuser) dockers/x86_64/ots/otsserver/.
```

### ots.btc.otsserver01.com OTS server

```shell
docker run -d --rm --mount type=bind,source="$HOME/.bitcoin",target="/otsuser/.bitcoin" --mount type=bind,source="$HOME/otsd/otsserver01",target="/otsuser/.otsd" --name otsnode-otsserver01 --network spbtcnodenet -e "VIRTUAL_HOST=ots.btc.otsserver01.com,btc.calendar.otsserver01.com" -e "LETSENCRYPT_HOST=ots.btc.otsserver01.com,btc.calendar.otsserver01.com" -e "LETSENCRYPT_EMAIL=security@otsserver01.com" --expose 14788 otsserver
```

### btc.ots.otsserver02.com OTS server

```shell
docker run -d --rm --mount type=bind,source="$HOME/.bitcoin",target="/otsuser/.bitcoin" --mount type=bind,source="$HOME/otsd/otsserver02",target="/otsuser/.otsd" --name otsnode-otsserver02 --network spbtcnodenet -e "VIRTUAL_HOST=ots.btc.otsserver02.com,btc.calendar.otsserver02.com" -e "LETSENCRYPT_HOST=ots.btc.otsserver02.com,btc.calendar.otsserver02.com" -e "LETSENCRYPT_EMAIL=security@otsserver02.com" --expose 14789 otsserver
```

## Our OTS Client
(please make copies of your OTS files, they may be deleted when you remove this container)

```shell
docker build -t otsclient dockers/x86_64/ots/otsclient/.
docker run --rm -it --name otsclient otsclient
```

### Client examples

```shell
ots -v stamp -m 1 myfile1.ext
ots -v info myfile1.ext.ots
ots -v upgrade myfile1.ext.ots
ots -v info myfile1.ext.ots
ots -v -l "https://btc.ots.otsserver01.com" stamp -c "https://btc.ots.otsserver01.com" -m 1 myfile2.ext
ots -v info myfile2.ext.ots
ots -v -l "https://btc.ots.otsserver01.com" upgrade myfile2.ext.ots
ots -v info myfile2.ext.ots
```
