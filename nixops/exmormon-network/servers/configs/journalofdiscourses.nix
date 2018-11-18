{ pkgs, lib, useSSL ? false, ... }:

let
  jodUrl = "journalofdiscourses.com";
  dbName = "journalofdiscourses";
  dbUser = "journal_ro";
  journalofdiscourses = import ../apps/journalofdiscourses {
    inherit pkgs dbName dbUser;
    dbHost = "localhost";
  };
in {
  acme.certs = if useSSL then { "${jodUrl}".email = "nocoolnametom@gmail.com"; } else {};
  mysql = {
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
  phpfpm.poolConfigs.${jodUrl} = ''
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
  users.extraUsers.${dbUser}.uid = 1001;
  nginx.virtualHosts."${jodUrl}" = {
    forceSSL = true;
    enableACME = true;
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
}