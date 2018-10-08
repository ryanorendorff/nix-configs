{ pkgs, ... }:

let
  api = "https://api.coinmarketcap.com/v1/ticker/bitcoin/";
in pkgs.writeScript "bitcoin" ''
  #!/usr/bin/env bash
  echo "$(curl '${api}' -s | jq '.[0] | "$\(.price_usd|tonumber|floor) \(.percent_change_1h)%"' | sed 's/"//g')"
''