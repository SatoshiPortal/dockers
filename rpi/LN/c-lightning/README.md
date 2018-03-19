# C-lightning LN implementation

## Assumptions

[Your lightning network user is created.](https://github.com/SatoshiPortal/docker/tree/master/rpi/LN)

## (if not using existing files): Create lightning and bitcoin working directories 

```shell
mkdir ~/.lightning ~/.bitcoin
```

## Apply permissions to working directories

```shell
sudo chown -R lnuser:pi ~/.lightning ~/.bitcoin ; sudo chmod g+ws ~/.lightning ~/.bitcoin
```

## (if using existing files): Recursively apply permissions to existing files

```shell
sudo find ~/.lightning ~/.bitcoin -type d -exec chmod 2775 {} \; ; sudo find ~/.lightning ~/.bitcoin -type f -exec chmod g+rw {} \;
```

## Create file .bitcoin/bitcoin.conf
(replacing `192.168.x.y` with Bitcoin node IP and `rpcusername/rpcpassword` with RPC username/password)

```properties
rpcconnect=192.168.x.y
rpcuser=rpcusername
rpcpassword=rpcpassword
testnet=1
```

## Create file .lightning/config, using your node alias, color, port and network

```properties
alias=SatoshiPortal01
rgb=008000
port=9735
network=testnet
```

## Build image

```shell
docker build --build-arg USER_ID=$(id -u lnuser) --build-arg GROUP_ID=$(id -g lnuser) .
```

## Get image ID

```shell
docker images
```

## Start LN server in container
(replacing `4c5bb5da3d29` with actual image ID and `SP-CLN01` with container name)

```shell
docker run -d --rm --name SP-CLN01 --mount type=bind,source="$HOME/.bitcoin",target="/lnuser/.bitcoin" --mount type=bind,source="$HOME/.lightning",target="/lnuser/.lightning" -p 9735:9735 4c5bb5da3d29
```

## If needed, re-apply permissions to newly created files

```shell
sudo find ~/.lightning ~/.bitcoin -type d -exec chmod 2775 {} \; ; sudo find ~/.lightning ~/.bitcoin -type f -exec chmod g+rw {} \;
```

## To get the node public key, type
(replace `7cff61b1567f` by actual container ID)

```shell
docker exec 7c lightning-cli getinfo
docker logs 7c
```
