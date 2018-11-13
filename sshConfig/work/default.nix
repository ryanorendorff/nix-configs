{ lib, pkgs, ... }:

[
  {
    host = "bastion.stage.ap.truaws.com";
    user = "apops";
    identityFile = toString ../../keys/private/stage-apops;
    identitiesOnly = true;
    port = null;
    forwardX11 = false;
    forwardX11Trusted = false;
    hostname = "bastion.stage.ap.truaws.com";
    serverAliveInterval = 0;
    compression = null;
    proxyCommand = null;
    extraOptions = {
      ForwardAgent = "yes";
      ControlMaster = "auto";
      ControlPath = "~/.ssh/stage-%r@%h:%p";
      ControlPersist = "5m";
    };
  }
  {
    host = "10.130.128.* 10.130.129.* 10.130.13?.* 10.130.14?.* 10.130.15?.* 10.130.16?.* 10.130.17?.* 10.130.18?.* 10.130.190.* 10.130.191.*";
    proxyCommand = "ssh bastion.stage.ap.truaws.com -W %h:%p";
    identityFile = toString ../../keys/private/stage-apops;
    identitiesOnly = true;
    user = "apops";
    extraOptions = {
      UserKnownHostsFile = "/dev/null";
      StrictHostKeyChecking = "no";
    };
  }
  {
    host = "fedev";
    hostname = "fedevsv2.sv2.trulia.com";
    identityFile = toString ../../keys/private/id_rsa;
    user = "tdoggett";
  }
  {
    host = "stage.aws";
    hostname = "bastion.stage.ap.truaws.com";
    identityFile = toString ../../keys/private/mysqlaccess;
    user = "mysqlaccess";
  }
  {
    host = "gitlab-zillow";
    hostname = "git.agentplatform.net";
    identityFile = toString ../../keys/private/trulia_rsa;
    user = "git";
  }
  {
    host = "stash.sv2.trulia.com";
    hostname = "stash.sv2.trulia.com";
    identityFile = toString ../../keys/private/trulia_rsa;
    user = "git";
    port = 7999;
  }
  {
    host = "stash";
    hostname = "stash.sv2.trulia.com";
    identityFile = toString ../../keys/private/trulia_rsa;
    user = "git";
    port = 7999;
  }
]