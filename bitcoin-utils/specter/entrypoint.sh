#!/bin/sh

ip=${1}

[ -n "${ip}" ] && exec python3 -m cryptoadvance.specter server --host ${ip}
[ -z "${ip}" ] && exec python3 -m cryptoadvance.specter server
