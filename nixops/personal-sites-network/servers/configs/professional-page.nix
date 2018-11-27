{ pkgs, useSSL ? false, ... }:

let
  professionalPageUrl = "tomdoggett.net";
in {
  acme.certs = if useSSL then { "${professionalPageUrl}".email = "nocoolnametom@gmail.com"; } else {};
  nginx.virtualHosts."${professionalPageUrl}" = {
    forceSSL = useSSL;
    enableACME = useSSL;
    http2 = useSSL;
    serverAliases = [ "www.${professionalPageUrl}" professionalPageUrl ];
    root = "${pkgs.callPackage ../apps/professional-page {}}/dist";
  };
}