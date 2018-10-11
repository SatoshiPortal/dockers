# Setting up a Lightning Network node on a Raspberry Pi!

## Lightning Network Node

There are at least 3 implementations of a lightning network node:

- c-lightning (Blockstream)
- lnd (Lightning Labs)
- eclair (Eclair)

Let’s run all of them each in a Docker container, on a Raspberry Pi!

## Assumptions

[You have a working RPi.](..)

## Create lnuser that will run the processes

Log in your RPi and:

```shell
sudo useradd lnuser
```
