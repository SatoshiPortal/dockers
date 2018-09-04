# Setting up a Lightning Network node on a x86_64 machine!

## Lightning Network Node

There are at least 3 implementations of a lightning network node:

- c-lightning (Blockstream)
- lnd (Lightning Labs)
- eclair (Eclair)

Let’s run all of them each in a Docker container, on a x86_64 machine!

## Create lnuser that will run the processes

Log in your x86_64 machine and:

```shell
sudo useradd lnuser
```
