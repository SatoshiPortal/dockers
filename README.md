# Bitcoin-related Dockerfiles and configurations

This is the public repository of dockerfiles used **in production** by [Satoshi Portal](https://www.satoshiportal.com/) for the Bitcoin applications it develops and operates, including [Bylls](https://www.bylls.com/) and [Bitcoin Outlet](https://www.bitcoinoutlet.com/).

We regularily update the existing Dockerfiles and add more. 
<br>See subdirectories for what you are looking for.

**Please submit improvements and post your comments, we definitely want to get better with your help!**

This repo is hosted at [bitcoindockers.com](http://www.bitcoindockers.com/)

# Features

- Lightweight alpine-based docker containers (runnable on RPi’s and other small devices)
- Using less possible new code, most possible existing OS built-in/well-known softwares
- Using container OS as running platform instead of language-based interpreter
- Encrypting everything through Docker Encrypted Overlay Network
- Distributing everything through Docker Swarm to maximize scallability
- Exposing nothing outside the overlay network

Our philosophy: Security, Lightweight, Performance & Security.

<br>
<hr>

# List of Dockerfiles

- [**HD address derivation (segwit, bech32, etc.)**:](https://github.com/SatoshiPortal/dockers/tree/master/bitcoin/hd-wallet-derive) a command-line too to derive bitcoin addresses using master public keys. This is useful for generating Bitcoin receiving addresses.
- [**Pycoin**:](https://github.com/SatoshiPortal/dockers/tree/master/bitcoin/pycoin) a crypto-utility useful for deriving Bitcoin addresses in Python.
- [**Bitcoin Core x86_64**:](https://github.com/SatoshiPortal/dockers/tree/master/x86_64/bitcoin-core)  the Bitcoin reference implementation (full node) of Bitcoin from [Bitcoin Core](https://bitcoincore.org/)
- [**Bitcoin Core for Raspberry Pi**:](https://github.com/SatoshiPortal/dockers/tree/master/rpi/bitcoin-core)   the Bitcoin reference implementation (full node) of Bitcoin from [Bitcoin Core](https://bitcoincore.org/) **optmized for running on a [Raspberry Pi](https://www.raspberrypi.org/) device**
- [**C-Lightning**:](https://github.com/SatoshiPortal/dockers/tree/master/rpi/LN/c-lightning)  one of the major Lightning Network implementations **optmized for running on a [Raspberry Pi](https://www.raspberrypi.org/) device**
- [**LND Lighnting Network Node**](https://github.com/SatoshiPortal/dockers/tree/master/rpi/LN/lnd)  one of the major Lightning Network implementations **optmized for running on a [Raspberry Pi](https://www.raspberrypi.org/) device**
- [**OpenTimestamp Server**:](https://github.com/SatoshiPortal/dockers/tree/master/x86_64/ots/otsserver) a network calendar and aggregation utility service for scalable timestamping of hashed data using the Bitcoin blockchain as a notary, from [Open Timestamps](https://www.opentimestamps.org/)
- [**OpenTimestamp Client**:](https://github.com/SatoshiPortal/dockers/tree/master/x86_64/ots/otsclient) software to communicate with OTS server and Bitcoin Core to generate and verify timestamps compliant with the [Open Timestamps](https://www.opentimestamps.org/) protocol

## Install git to clone this project

```shell
sudo apt-get install git
```

## Extract this project on the machine

```shell
git clone https://github.com/SatoshiPortal/dockers.git
```
<br>
<hr>

# TODO

- Update LND
- A lot of improvements
- More details in the docs
- Electrum Personal Server
- Electrum Server

# Contributions are welcome!

Thanks for the pull requests :)

For questions and comments please create an issue.
