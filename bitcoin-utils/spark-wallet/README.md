# Spark Wallet Docker Container

This Docker container is based on Alpine.

## Build

```bash
docker build -t cyphernode/sparkwallet:v0.3.0 .
```

## Run

```bash
docker run --rm -d -p 9737:9737 -v "${LIGHTNING_DATAPATH}/${NETWORK}:/etc/lightning" -v "${APP_SCRIPT_PATH}/cookie:/data/spark/cookie" -v "${GATEKEEPER_DATAPATH}/htpasswd:/htpasswd/htpasswd" cyphernode/sparkwallet:v0.3.0 $(id -u):$(id -g) /entrypoint.sh "0.0.0.0"
```

Then point your browser to http://localhost:9737 and enjoy!

## Cyphernode integration

Please see https://github.com/SatoshiPortal/cypherapps/blob/master/sparkwallet/docker-compose.yaml to see how Spark Wallet is integrated as a cypherapp in Cyphernode.

