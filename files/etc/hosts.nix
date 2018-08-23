{ prefix ? "", ... }:

{
  "${prefix}hosts" = {
    text = ''
      127.0.0.1       localhost localhost.zillow.local
      255.255.255.255 broadcasthost
      ::1             localhost localhost.zillow.local
      fe80::1%lo0	    localhost localhost.zillow.local

      # These are because the office DNS doesn't work well with ChunkWM,
      # so I preceed it with Google's 8.8.8.8 in settings, but that
      # breaks the following URIs.
      10.202.8.69     splunk.zillow.local lyn-splunk.zillow.local
      172.19.13.128   jira.corp.trulia.com
      172.19.56.53    stash.sv2.trulia.com
      192.168.245.78  zwiki.zillowgroup.net
    '';
  };
}