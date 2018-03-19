# Lnd LN implementation

## Assumptions

[Your lightning network user is created.](https://github.com/SatoshiPortal/docker/tree/master/rpi/LN)

## (if not using existing files): Create the lnd working directory 

```shell
mkdir ~/.lnd
```

## Create lnd config file ~/.lnd/lnd.conf
(replacing `192.168.x.y`, `rpcusername/rpcpassword` and others by your actual values)

```properties
[Application Options]
debuglevel=debug
debughtlc=true
maxpendingchannels=10
noencryptwallet=1

[Bitcoin]
bitcoin.active=1
bitcoin.testnet=1
bitcoin.node=bitcoind

[bitcoind]
bitcoind.rpchost=192.168.x.y
bitcoind.rpcuser=rpcusername
bitcoind.rpcpass=rpcpassword
bitcoind.zmqpath=tcp://192.168.x.y:29000
```

## Apply permissions to working directory

```shell
sudo chown -R lnuser:pi ~/.lnd ; sudo chmod g+ws ~/.lnd
```

## (if using existing files): Recursively apply permissions to existing files

```shell
sudo find ~/.lnd -type d -exec chmod 2775 {} \; ; sudo find ~/.lnd -type f -exec chmod g+rw {} \;
```

## Build docker image

```shell
docker build --build-arg USER_ID=$(id -u lnuser) --build-arg GROUP_ID=$(id -g lnuser) .
```

## Run docker image
(replacing `e441c719a91f` by your image ID and `SP-LND01` by the container name you want)

```shell
docker run -d --rm --name SP-LND01 --mount type=bind,source="$HOME/.lnd",target="/lnuser/.lnd" -p 10009:10009 -p 9735:9735 e441c719a91f
```

## If needed, re-apply permissions to newly created files

```shell
sudo find ~/.lnd -type d -exec chmod 2775 {} \; ; sudo find ~/.lnd -type f -exec chmod g+rw {} \;
```

## Use lncli to stop daemon, get info, etc.
(replacing `6f816e577c9a` by your container ID)

```shell
docker exec -it 6f816e577c9a gosu lnuser lncli stop
docker exec -it 6f816e577c9a gosu lnuser lncli getinfo
```
