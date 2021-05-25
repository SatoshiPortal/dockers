# Specter Docker Container

This Docker container is based on Alpine.  It will run the whole container as the specified user.

## Build

```bash
docker build -t cyphernode/specter:v1.3.1 .
```

## Run

```bash
docker run --rm -d -p 25441:25441 -v "$YOUR_DATAPATH/data:/.specter" -v "$BITCOIN_DATAPATH/bitcoin-client.conf:/.bitcoin/bitcoin.conf:ro" cyphernode/specter:v1.3.1 $(id -u):$(id -g) /entrypoint.sh "0.0.0.0"
```

Then point your browser to http://localhost:25441 and enjoy!

## Cyphernode integration

Please see https://github.com/SatoshiPortal/cypherapps/blob/features/specter/specter/docker-compose.yaml to see how Specter is integrated as a cypherapp in Cyphernode.

