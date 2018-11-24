{ config, lib, pkgs, ... }:

let
  useSSL = true;
  professionalPageConfig = pkgs.callPackage ./configs/professional-page.nix { inherit useSSL; };
in {
  # documentation.nixos.enable = false;
  services.nixosManual.enable = false;

  system.stateVersion = "18.09";
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 22 ] ++ (if useSSL then [ 443 ] else []);
  networking.firewall.allowPing = true;

  security.acme.certs = {}
    // professionalPageConfig.acme.certs
  ;

  services.nginx.enable = true;
  services.nginx.statusPage = false;

  # Use recommended settings
  services.nginx.recommendedGzipSettings = true;
  services.nginx.recommendedOptimisation = true;
  services.nginx.recommendedProxySettings = true;
  services.nginx.recommendedTlsSettings = true;

  # Only allow PFS-enabled ciphers with AES256
  services.nginx.sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

  services.nginx.commonHttpConfig = ''
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

  services.nginx.virtualHosts = {}
    // professionalPageConfig.nginx.virtualHosts
  ;
}
