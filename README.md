# Bitcoin-related Dockerfiles and configurations

This is the public repository of dockerfiles used **in production** by [Satoshi Portal](https://www.satoshiportal.com/) for the Bitcoin applications it develops and operates, including [Bylls](https://www.bylls.com/) and [Bull Bitcoin](https://www.bullbitcoin.com/).

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

Our philosophy: Security, Lightweight, Performance & Scalability.

<br>
<hr>

# List of Dockerfiles

- [**Bitcoin Core**:](https://github.com/SatoshiPortal/dockers/tree/master/bitcoin-core) the Bitcoin reference implementation (full node) of Bitcoin from [Bitcoin Core](https://bitcoincore.org/)
- [**Elements**:](https://github.com/SatoshiPortal/dockers/tree/master/liquid) the Elements (Liquid) reference implementation (full node) of Elements sidechains from [Elements Project](https://elementsproject.org/)
- [**C-Lightning**:](https://github.com/SatoshiPortal/dockers/tree/master/c-lightning) one of the major Lightning Network implementations
- [**Pycoin**:](https://github.com/SatoshiPortal/dockers/tree/master/bitcoin-utils/pycoin) a crypto-utility useful for deriving Bitcoin addresses in Python.
- [**Electrum Personal Server**:]
- [**HD address derivation (segwit, bech32, etc.)**:](https://github.com/SatoshiPortal/dockers/tree/master/bitcoin-utils/hd-wallet-derive) a command-line tool to derive bitcoin addresses using master public keys. This is useful for generating Bitcoin receiving addresses.
- [**OpenTimestamp Server**:](https://github.com/SatoshiPortal/dockers/tree/master/ots/otsserver) a network calendar and aggregation utility service for scalable timestamping of hashed data using the Bitcoin blockchain as a notary, from [Open Timestamps](https://www.opentimestamps.org/)
- [**OpenTimestamp Client**:](https://github.com/SatoshiPortal/dockers/tree/master/ots/otsclient) software to communicate with OTS server and Bitcoin Core to generate and verify timestamps compliant with the [Open Timestamps](https://www.opentimestamps.org/) protocol

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

# Wishlist

If you want us to add a docker, please create an issue this way:

- Paste the source code of the repository you want us to add
- Tell us why you think this is useful and/or how you (or you think someone else) may want to use it. This will help us prioritize and think of the actual usage.
- Put the label "wishlist" on the issue.
