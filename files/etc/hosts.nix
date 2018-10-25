{ prefix ? "", ... }:

{
  "${prefix}hosts" = {
    text = ''
      127.0.0.1       localhost localhost.zillow.local tdoggett4.zillow.local
      255.255.255.255 broadcasthost
      ::1             localhost localhost.zillow.local tdoggett4.zillow.local
      fe80::1%lo0	    localhost localhost.zillow.local tdoggett4.zillow.local

      # These are because the office DNS doesn't work well with ChunkWM,
      # so I preceed it with Google's 8.8.8.8 in settings, but that
      # breaks the following URIs.
      10.202.8.69     splunk.zillow.local lyn-splunk.zillow.local
      172.19.13.128   jira.corp.trulia.com
      172.19.14.104   fedevdb3.sv2.trulia.com
      172.19.51.98    feutil1.sv2.trulia.com
      172.19.56.41    stage-user-profile-service.sv2.trulia.com user-profile-service.sv2.trulia.com
      172.19.56.53    stash.sv2.trulia.com
      172.19.56.81    artifact-repo.sv2.trulia.com
      172.19.58.214   npm-int-0-1.sv2.trulia.com
      172.19.58.234   agentplatform-jenkins-master.sv2.trulia.com
      172.22.14.78    ric-zit-jet-001.zillow.local
      192.168.245.78  zwiki.zillowgroup.net
      10.130.128.216  gitlab.int.ap.truaws.com
    '';
  };
}
