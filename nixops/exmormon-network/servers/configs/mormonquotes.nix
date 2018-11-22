{ pkgs, lib, useSSL ? false, ... }:

let
  mormonQuotesUrl = "mormonquotes.com";
  dbName = "mormonquotes";
  dbUser = "moquotes_ro";
  mormonquotes = import ../apps/mormonquotes {
    inherit pkgs dbName dbUser;
    dbHost = "localhost";
  };
in {
  acme.certs = if useSSL then { "${mormonQuotesUrl}".email = "nocoolnametom@gmail.com"; } else {};
  mysql = {
    initialDatabases = [
      {
        name = dbName;
        schema = mormonquotes.sqlDataFile;
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
  phpfpm.poolConfigs.${mormonQuotesUrl} = ''
    listen = /var/run/${mormonQuotesUrl}-phpfpm.sock
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
  users.extraUsers.${dbUser}.uid = 1002;
  nginx.virtualHosts."${mormonQuotesUrl}" = {
    forceSSL = true;
    enableACME = true;
    serverAliases = [ "www.${mormonQuotesUrl}" mormonQuotesUrl ];
    root = "${mormonquotes.package}/public";
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
        tryFiles = "$uri =404";
        extraConfig = ''
          fastcgi_pass unix:/var/run/${mormonQuotesUrl}-phpfpm.sock;
          fastcgi_index index.php;
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
          fastcgi_intercept_errors on;
          expires -1;
        '';
      };
      "/" = {
        index = "index.php";
        tryFiles = "$uri $uri/ $uri.php";
      };
    } // (
      # This converts the URL Regex patterns from the MormonQuotes package into NGINX rewrites
      lib.mapAttrs' (regex: target: lib.nameValuePair ("~* " + regex) { extraConfig = ("rewrite " + regex + " " + target + ";"); }) mormonquotes.rewrites
    );
  };
}