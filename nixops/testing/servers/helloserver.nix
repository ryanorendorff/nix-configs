{ config, lib, pkgs, ... }:

let
  jodUrl = "journalofdiscourses.com";
  cesboxUrl = "cesletterbox.com";
  dbName = "journalofdiscourses";
  dbUser = "journal_ro";
  cesletterbox = pkgs.callPackage ./apps/cesletterbox {};
  journalofdiscourses = import ./apps/journalofdiscourses {
    inherit pkgs dbName dbUser;
    dbHost = "localhost";
  };
in {
  documentation.nixos.enable = false;

  system.stateVersion = "18.03";
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];
  networking.firewall.allowPing = true;

  security.acme.certs = {
    # "${cesboxUrl}".email = "nocoolnametom@gmail.com";
    # "${jodUrl}".email = "nocoolnametom@gmail.com";
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
          "${dbName}.*" = "SELECT";
        };
      }
    ];
  };

  users.extraUsers.${dbUser} = {
    uid = 1001;
  };

  services.phpfpm.poolConfigs.${jodUrl} = ''
    listen = /var/run/${jodUrl}-phpfpm.sock
    user = ${dbUser}
    pm = dynamic
    pm.max_children = 32
    pm.max_requests = 500
    pm.start_servers = 2
    pm.min_spare_servers = 2
    pm.max_spare_servers = 5
    listen.owner = nginx
    listen.group = nginx
    listen.mode = 0660
    php_admin_value[error_log] = 'stderr'
    php_admin_flag[log_errors] = on
    env[PATH] = ${lib.makeBinPath [ pkgs.php ]}
    catch_workers_output = yes
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
      "${jodUrl}" = {
        # addSSL = true;
        # forceSSL = true;
        # enableACME = true;
        serverAliases = [ "www.${jodUrl}" jodUrl ];
        root = "${journalofdiscourses.package}/public";
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
          "~ \.(php|phtml)$" = {
            extraConfig = ''
              fastcgi_pass unix:/var/run/${jodUrl}-phpfpm.sock;
              fastcgi_index index.php;
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              include ${pkgs.nginx}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
              expires -1;
            '';
          };
        } // (
          # This converts the URL Regex patterns from the JournalOfDiscourses package into NGINX rewrites
          lib.mapAttrs' (regex: target: lib.nameValuePair ("~* " + regex) { extraConfig = ("rewrite " + regex + " " + target + ";"); }) journalofdiscourses.rewrites
        );
      };
    };
  };
}
