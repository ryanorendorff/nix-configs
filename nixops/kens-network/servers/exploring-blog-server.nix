{ config, lib, pkgs, ... }:

let
  useSSL = false;
  exploringBlogConfig = pkgs.callPackage ./configs/exploring-blog.nix { inherit useSSL; };
in {
  # documentation.nixos.enable = false;
  services.nixosManual.enable = false;

  system.stateVersion = "18.09";
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 22 ] ++ (if useSSL then [ 443 ] else []);
  networking.firewall.allowPing = true;

  services.mysql = {
    enable = true;
    package = pkgs.mysql;
    initialDatabases = []
      ++ exploringBlogConfig.mysql.initialDatabases
    ;
    ensureDatabases = []
      ++ exploringBlogConfig.mysql.ensureDatabases
    ;
    ensureUsers = []
      ++ exploringBlogConfig.mysql.ensureUsers
    ;
  };

  services.fail2ban = {}
    // exploringBlogConfig.services.fail2ban
  ;

  services.mysqlBackup.enable = true;
  services.mysqlBackup.databases = []
    ++ exploringBlogConfig.mysqlBackup.databases
  ;

  systemd.services."writeableExploringBlogUploads" = exploringBlogConfig.systemd.services."writeableExploringBlogUploads";
  systemd.services."getNewExploringBlogSalts" = exploringBlogConfig.systemd.services."getNewExploringBlogSalts";

  users.extraUsers = {}
    // exploringBlogConfig.users.extraUsers
  ;

  users.extraGroups = {}
    // exploringBlogConfig.users.extraGroups
  ;

  services.phpfpm.poolConfigs = {}
    // exploringBlogConfig.phpfpm.poolConfigs
  ;

  security.acme.certs = {}
    // exploringBlogConfig.acme.certs
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
      // exploringBlogConfig.nginx.virtualHosts
    ;
  };
}
