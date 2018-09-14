# C-lightning LN implementation

## Assumptions

[Your lightning network user is created.](..)

## (if not using existing files): Create lightning and bitcoin working directories

```shell
mkdir ~/.lightning
cp config ~/.lightning/
```

## Apply permissions to working directories

```shell
sudo chown -R lnuser:pi ~/.lightning ; sudo chmod g+ws ~/.lightning
```

## (if using existing files): Recursively apply permissions to existing files

```shell
sudo find ~/.lightning -type d -exec chmod 2775 {} \; ; sudo find ~/.lightning -type f -exec chmod g+rw {} \;
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
docker build -t clnimg --build-arg USER_ID=$(id -u lnuser) --build-arg GROUP_ID=$(id -g lnuser) -f Dockerfile-alpine .
```

## Start LN server in container

```shell
docker run -d --rm --name cln --mount type=bind,source="$HOME/.lightning",target="/lnuser/.lightning" -p 9735:9735 clnimg
```

## If needed, re-apply permissions to newly created files

```shell
sudo find ~/.lightning -type d -exec chmod 2775 {} \; ; sudo find ~/.lightning -type f -exec chmod g+rw {} \;
```

## To get the node public key, type

```shell
docker logs -f cln
docker exec -it cln lightning-cli getinfo
docker exec -it cln lightning-cli stop
```
