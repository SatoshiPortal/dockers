# EPS

## Setup

First, do something like this:

```
sudo useradd bitcoinuser
```

...to create the user Bitcoin Core will run as.

```
docker swarm init --task-history-limit 1
docker network create --driver=overlay --attachable --opt encrypted epsnet
```

...to create the network within which EPS and Bitcoin Core will talk to each other.

## Start Bitcoin

```
docker run --name bitcoin --rm -d -v "$PWD/.bitcoin:/.bitcoin" --network epsnet cyphernode/bitcoin:v0.19.0.1 `id -u bitcoinuser`:`id -g bitcoinuser` bitcoind
```

## Start EPS

```
docker run -it --name eps -p 50002:50002 --network epsnet -v "$PWD/eps/config.ini:/eps/config.ini" eps
```

Or if you want to do some manipulations with EPS:

```
docker run -it --name eps -p 50002:50002 --network epsnet -v "$PWD/eps/config.ini:/eps/config.ini" --entrypoint ash eps
```
