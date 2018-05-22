{ lib, stdenv, pkgs, ... }:

[
  {
    host = "bastion.stage.ap.truaws.com";
    port = null;
    forwardX11 = false;
    forwardX11Trusted = false;
    identitiesOnly = true;
    identityFile = "~/.ssh/apd";
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
    host = "hassio.local";
    hostname = "hassio.local";
    identityFile = "~/.ssh/id_rsa";
    user = "root";
  }
  {
    host = "github.com";
    hostname = "github.com";
    identityFile = "~/.ssh/id_rsa";
    user = "git";
  }
  {
    host = "fedev";
    hostname = "fedevsv2.sv2.trulia.com";
    identityFile = "~/.ssh/id_rsa";
    user = "tdoggett";
  }
  {
    host = "stage.aws";
    hostname = "bastion.stage.ap.truaws.com";
    identityFile = "~/.ssh/mysqlaccess";
    user = "mysqlaccess";
  }
  {
    host = "remote_gollum";
    hostname = "home.nocoolnametom.com";
    identityFile = "~/.ssh/id_rsa";
    user = "pi";
    port = 22223;
  }
  {
    host = "remote_bill";
    hostname = "home.nocoolnametom.com";
    identityFile = "~/.ssh/id_rsa";
    user = "pi";
    port = 22224;
  }
  {
    host = "linode";
    hostname = "nocoolnametom.com";
    identityFile = "~/.ssh/id_rsa";
    user = "doggetto";
    port = 2222;
  }
  {
    host = "elrond";
    hostname = "45.33.53.132";
    identityFile = "~/.ssh/id_rsa";
    user = "tdoggett";
    port = 2222;
  }
  {
    host = "stash.sv2.trulia.com";
    hostname = "stash.sv2.trulia.com";
    identityFile = "~/.ssh/trulia_rsa";
    user = "git";
    port = 7999;
  }
  {
    host = "stash";
    hostname = "stash.sv2.trulia.com";
    identityFile = "~/.ssh/trulia_rsa";
    user = "git";
    port = 7999;
  }
  {
    host = "frodo";
    hostname = "frodo";
    identityFile = "~/.ssh/id_rsa";
    user = "pi";
  }
  {
    host = "bill";
    hostname = "bill";
    identityFile = "~/.ssh/id_rsa";
    user = "pi";
  }
  {
    host = "gollum";
    hostname = "gollum";
    identityFile = "~/.ssh/id_rsa";
    user = "pi";
  }
]
++ lib.optionals stdenv.isDarwin ( pkgs.callPackage ./darwin.nix {} )
++ lib.optionals stdenv.isLinux ( pkgs.callPackage ./linux.nix {} )