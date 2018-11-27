{ pkgs, useSSL ? false, ... }:

let
  beaconUrl = "lds.tech";
in {
  acme.certs = if useSSL then { "${beaconUrl}".email = "nocoolnametom@gmail.com"; } else {};
  nginx.virtualHosts."${beaconUrl}" = {
    forceSSL = useSSL;
    enableACME = useSSL;
    http2 = useSSL;
    serverAliases = [ "www.${beaconUrl}" beaconUrl "www.lds.support" "lds.support" ];
    root = "${pkgs.callPackage ../apps/lds-beacon-pages {}}";
    locations = {
      "= /" = {
        extraConfig = ''
          return 302 https://beta.lds.org ;
        '';
      };
      "~* ^/cs" = {
        extraConfig = ''
          rewrite ^/cs(.*) /cesletter$1 ;
        '';
      };
      "~* ^/wf" = {
        extraConfig = ''
          rewrite ^/wf(.*) /letterformywife$1 ;
        '';
      };
      "~* ^/es[0-9]+" = {
        extraConfig = ''
          rewrite ^/es(.*) /essay$1 ;
        '';
      };
      "/" = {
        extraConfig = ''
          if ($request_uri ~ ^/(.*)\.html$) {
            return 302 /$1;
          }
          try_files $uri $uri.html $uri/ =404;
        '';
      };
    };
  };
}