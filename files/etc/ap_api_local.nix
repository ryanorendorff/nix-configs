{ prefix ? "", pkgs, ... }:

{
  "${prefix}ap/api_local.json" = {
    text = ''
      {
        "appName": "aps-team-stats",
        "environment": "dev",
        "baseUriPath": "/",
        "dbHandles": "${(pkgs.callPackage ./db_handles_file {})}",
        "logFile": "/tmp/log.log",
        "logStashErrorFile": "/tmp/logStashErrors.log",
        "useAPCuMetadataCache" : "1",
        "useMobileProfileAuth": "1",
        "useEncryptedUserIdAuth": "1",
        "userProfileServiceHost": "stage-user-profile-service1.sv2.trulia.com",
        "zillowWebHost": "www.zillow.com"
      }
    '';
  };
}
