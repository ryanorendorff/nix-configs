{ config, lib, pkgs, ... }:

let
  useSSL = true;
  cesletterboxConfig = pkgs.callPackage ./configs/cesletterbox.nix { inherit useSSL; };
  jodConfig = pkgs.callPackage ./configs/journalofdiscourses.nix { inherit useSSL; };
  mormonQuotesConfig = pkgs.callPackage ./configs/mormonquotes.nix { inherit useSSL; };
  mormonCanonConfig = pkgs.callPackage ./configs/mormoncanon.nix { inherit useSSL; };
  beaconConfig = pkgs.callPackage ./configs/lds-beacon-pages.nix { inherit useSSL; };
in {
  # documentation.nixos.enable = false;
  services.nixosManual.enable = false;

  system.stateVersion = "18.09";
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 22 ] ++ (if useSSL then [ 443 ] else []);
  networking.firewall.allowPing = true;

  security.acme.certs = {}
    // jodConfig.acme.certs
    // mormonQuotesConfig.acme.certs
    // mormonCanonConfig.acme.certs
    // cesletterboxConfig.acme.certs
    // beaconConfig.acme.certs
  ;

  services.mysql = {
    enable = true;
    package = pkgs.mysql;
    initialDatabases = []
      ++ jodConfig.mysql.initialDatabases
      ++ mormonQuotesConfig.mysql.initialDatabases
      ++ mormonCanonConfig.mysql.initialDatabases
    ;
    ensureDatabases = []
      ++ jodConfig.mysql.ensureDatabases
      ++ mormonQuotesConfig.mysql.ensureDatabases
      ++ mormonCanonConfig.mysql.ensureDatabases
    ;
    ensureUsers = []
      ++ jodConfig.mysql.ensureUsers
      ++ mormonQuotesConfig.mysql.ensureUsers
      ++ mormonCanonConfig.mysql.ensureUsers
    ;
  };

  users.extraUsers = {}
    // jodConfig.users.extraUsers
    // mormonQuotesConfig.users.extraUsers
    // mormonCanonConfig.users.extraUsers
  ;

  services.phpfpm.poolConfigs = {}
    // jodConfig.phpfpm.poolConfigs
    // mormonQuotesConfig.phpfpm.poolConfigs
    // mormonCanonConfig.phpfpm.poolConfigs
  ;

  services.nginx = {
    enable = true;
    statusPage = false;

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

    virtualHosts = {}
      // jodConfig.nginx.virtualHosts
      // mormonQuotesConfig.nginx.virtualHosts
      // mormonCanonConfig.nginx.virtualHosts
      // cesletterboxConfig.nginx.virtualHosts
      // beaconConfig.nginx.virtualHosts
    ;
  };
}
