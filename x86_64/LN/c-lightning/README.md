# C-lightning LN implementation

## Assumptions

[Your lightning network user is created.](..)

## (if not using existing files): Create lightning and bitcoin working directories

```shell
mkdir -m 2770 -p ~/lndata
cp config ~/lndata
```

## Apply permissions to working directories

```shell
sudo chown -R lnuser:debian ~/lndata
```

## (if using existing files): Recursively apply permissions to existing files

```shell
sudo find ~/lndata -type f -exec chmod g+rw {} \; ; sudo find ~/lndata -type d -exec chmod g+rwx {} \;
```

## Edit file bitcoin.conf (will be .bitcoin/bitcoin.conf)
(replacing `btcnode` with Bitcoin node IP/name and `rpcusername/rpcpassword` with RPC username/password)

```properties
rpcconnect=btcnode
rpcuser=rpcusername
rpcpassword=rpcpassword
testnet=1
rpcwallet=ln01.dat
```

## Edit file config (will be .lightning/config), using your node alias, color, port and network

```properties
alias=SatoshiPortal01
rgb=008000
#port=9735
network=testnet
```

## Build image

```shell
docker build -t clnimg .
```

## Start LN server in container

```shell
docker run -d --rm --name cln -p 9735:9735 -v /home/pi/lndata:/.lightning clnimg `id -u lnuser`:`id -g lnuser` lightningd
```

## If needed, re-apply permissions to newly created files

```shell
sudo find ~/lndata -type f -exec chmod g+rw {} \; ; sudo find ~/lndata -type d -exec chmod g+rwx {} \;
```

## To get the node public key, type

```shell
docker logs -f cln
docker exec -it cln lightning-cli getinfo
docker exec -it cln lightning-cli stop
```
