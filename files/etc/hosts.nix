{ prefix ? "", ... }:

{
  "${prefix}hosts" = {
    text = ''
      127.0.0.1       localhost localhost.zillow.local
      255.255.255.255 broadcasthost
      ::1             localhost localhost.zillow.local
    '';
  };
}