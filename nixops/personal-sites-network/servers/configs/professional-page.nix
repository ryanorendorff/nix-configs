{ pkgs, useSSL ? false, ... }:

let
  professionalPageUrl = "lds.tech";
in {
  acme.certs = if useSSL then { "${professionalPageUrl}".email = "nocoolnametom@gmail.com"; } else {};
  nginx.virtualHosts."${professionalPageUrl}" = {
    forceSSL = useSSL;
    enableACME = useSSL;
    serverAliases = [ "www.${professionalPageUrl}" professionalPageUrl ];
    root = "${pkgs.callPackage ../apps/professional-page {}}/dist";
  };
}