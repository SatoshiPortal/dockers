#!/bin/sh

ip=${1}

[ -n "${ip}" ] && python3 -m cryptoadvance.specter server --host ${ip}
[ -z "${ip}" ] && python3 -m cryptoadvance.specter server
