{ pkgs, ... }:

let
  api = "https://api.coinmarketcap.com/v1/ticker/ethereum/";
in pkgs.writeScript "ethereum" ''
  #!/usr/bin/env bash
  echo "$(curl '${api}' -s | jq '.[0] | "$\(.price_usd|tonumber|floor) \(.percent_change_1h)%"' | sed 's/"//g')"
''