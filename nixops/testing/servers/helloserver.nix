{ config, pkgs, ... }:

let
  phpPort = "9000";
  dbName = "journalofdiscourses";
  dbUser = "journal_ro";
  cesletterbox = pkgs.callPackage ./apps/cesletterbox {};
  journalofdiscourses = import ./apps/journalofdiscourses {
    inherit pkgs dbName dbUser;
    dbHost = "localhost";
  };
in {
  services.nixosManual.enable = false;

  system.nixos.stateVersion = "18.03";
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 22 ];
  networking.firewall.allowPing = true;

  security.acme.certs = {
    # "cesletterbox.com".email = "nocoolnametom@gmail.com";
    # "journalofdiscourses.com".email = "nocoolnametom@gmail.com";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mysql;
    initialDatabases = [
      {
        name = dbName;
        schema = journalofdiscourses.sqlDataFile;
      }
    ];
    ensureDatabases = [
      dbName
    ];
    ensureUsers = [
      {
        name = dbUser;
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
          # "${dbName}.*" = "SELECT";
        };
      }
    ];
  };

  services.phpfpm.poolConfigs.mypool = ''
    listen = 127.0.0.1:${phpPort}
    user = nobody
    pm = dynamic
    pm.max_children = 5
    pm.start_servers = 2
    pm.min_spare_servers = 1
    pm.max_spare_servers = 3
    pm.max_requests = 500
  '';

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
      add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

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
      "cesletterbox.com" = {
        # forceSSL = true;
        # enableACME = true;
        serverAliases = [ "www.cesletterbox.com" "cesletterbox.com" ];
        root = "${cesletterbox}";
      };
      "journalofdiscourses.com" = {
        ###### NEED TO USE THE ROUTS IN journalofdiscourses.rewrites! ###########
        # forceSSL = true;
        # enableACME = true;
        serverAliases = [ "www.journalofdiscourses.com" "journalofdiscourses.com" ];
        root = "${journalofdiscourses.package}/public";
        locations."~ \.php$".extraConfig = ''
          fastcgi_pass 127.0.0.1:${phpPort};
          fastcgi_index index.php;
        '';
      };
    };
  };
}
