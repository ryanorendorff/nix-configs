{ config, lib, pkgs, ... }:

let
  cesboxUrl = "cesletterbox.com";
  cesletterbox = pkgs.callPackage ./apps/cesletterbox {};
in {
  # documentation.nixos.enable = false;

  system.stateVersion = "18.03";
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];
  networking.firewall.allowPing = true;

  security.acme.certs = {
    # "${cesboxUrl}".email = "nocoolnametom@gmail.com";
  };

  services.nginx = {
    enable = true;
    statusPage = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    commonHttpConfig = ''
      # Enable CSP for your services.
      #  add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      # Minimize information leaked to other domains
      add_header 'Referrer-Policy' 'origin-when-cross-origin';

      # Disable embedding as a frame
      add_header X-Frame-Options DENY;

      # Prevent injection of code in other mime types (XSS Attacks)
      add_header X-Content-Type-Options nosniff;

      # Enable XSS protection of the browser.
      # May be unnecessary when CSP is configured properly (see above)
      add_header X-XSS-Protection "1; mode=block";

      # A man is not dead while his name is still spoken.
      add_header X-Clacks-Overhead "GNU Terry Pratchett";
      autoindex on;
    '';

    virtualHosts = {
      "${cesboxUrl}" = {
        # addSSL = true;
        # forceSSL = true;
        # enableACME = true;
        serverAliases = [ "www.${cesboxUrl}" cesboxUrl ];
        root = "${cesletterbox}";
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
    };
  };
}
