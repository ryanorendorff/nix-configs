{ pkgs, useSSL ? false, ... }:

let
  cesboxUrl = "cesletterbox.com";
in {
  acme.certs = if useSSL then { "${cesboxUrl}".email = "nocoolnametom@gmail.com"; } else {};
  nginx.virtualHosts."${cesboxUrl}" = {
    forceSSL = useSSL;
    enableACME = useSSL;
    serverAliases = [ "www.${cesboxUrl}" cesboxUrl ];
    root = "${pkgs.callPackage ../apps/cesletterbox {}}";
    locations = {
      "/favicon.ico" = {
        extraConfig = ''
          log_not_found off;
          access_log off;
        '';
      };
      "/robots.txt" = {
        extraConfig = ''
          allow all;
          log_not_found off;
          access_log off;
        '';
      };
      "~* \.(css|js|gif|jpe?g|png)$" = {
        extraConfig = ''
          expires 168h;
          add_header Pragma public;
          add_header Cache-Control "public, must-revalidate, proxy-revalidate";
        '';
      };
    };
  };
}