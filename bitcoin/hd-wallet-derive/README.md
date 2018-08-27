# Build image

```shell
docker build -t hdwd .
```

# Run container

```shell
docker run -it --rm hdwd
```

# Usefull examples

See https://github.com/dan-da/hd-wallet-derive

List of the first 10 SegWit addresses for a pub32:

```shell
./hd-wallet-derive.php -g --key=upub5GtUcgGed1aGH4HKQ3vMYrsmLXwmHhS1AeX33ZvDgZiyvkGhNTvGd2TA5Lr4v239Fzjj4ZY48t6wTtXUy2yRgapf37QHgt6KWEZ6bgsCLpb --coin=btc-test --path="m/0" --numderive=10
```
