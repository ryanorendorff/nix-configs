{...}:

let
  api = "https://api.coinmarketcap.com/v1/ticker/bitcoin/";
in ''
  #!/usr/bin/env bash
  echo "$(curl '${api}' -s | jq '.[0] | "$\(.price_usd) \(.percent_change_1h)%"' | sed 's/"//g')"
''