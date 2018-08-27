{ prefix ? "", pkgs, ... }:

{
  "${prefix}.credentials/calendar-go-quickstart.json" = {
    source = ../../keys/private/token.json;
  };
}