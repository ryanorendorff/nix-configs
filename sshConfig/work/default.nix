{ lib, pkgs, ... }:

[
  {
    host = "bastion.stage.ap.truaws.com";
    port = null;
    forwardX11 = false;
    forwardX11Trusted = false;
    identitiesOnly = true;
    identityFile = toString ../../keys/private/apd;
    user = "apd";
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