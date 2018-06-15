{ prefix ? "", ... }:

{
  "${prefix}trulia/server.json" = {
    text = ''
      { "SERVER": "DEV" }
    '';
  };
}