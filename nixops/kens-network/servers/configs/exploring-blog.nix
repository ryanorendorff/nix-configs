{ pkgs, config, lib, useSSL ? false, ... }:

let
  exploringBlogUrl = "exploringmormonism.com";
  dbHost = "localhost";
  dbName = "exploringmormonism";
  dbUser = "exploringmormonism";
  uploadsDir = "/var/uploads/exploringmormonism/";
  saltsFile = "/var/data/exploringmormonism/salts";
  wordpressRoot = pkgs.callPackage ../apps/wordpress-root {
    inherit pkgs dbName dbUser dbHost uploadsDir saltsFile;
    themes = [
      "kens-twentyten"
      "twentyseventeen"
    ];
    plugins = [
      "akismet"
      "classic-editor"
      "column-shortcodes"
      "excel-interactive-view"
      "excel-to-table"
      "simple-csv-table"
      "youtube-embed-plus"
    ];
  };
in {
  systemd.services."writeableExploringBlogUploads" = {
    enable = true;
    description = "Ensuring Exploring Blog has a writeable uploads folder";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      mkdir -p ${uploadsDir};
      find ${uploadsDir} -type d -exec chmod 755 {} \;
      find ${uploadsDir} -type f -exec chmod 644 {} \;
      chown -R nginx:nginx ${uploadsDir};
    '';
  };
  systemd.services."getNewExploringBlogSalts" = {
    enable = true;
    description = "Ensuring Exploring Blog has a new salts file";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.iputils pkgs.curl ];
    script = ''
      rm -f ${saltsFile}.php;
      curl https://api.wordpress.org/secret-key/1.1/salt/ --output ${saltsFile}.php;
      printf '%s\n%s\n' "<?php" "$(cat ${saltsFile}.php)" > ${saltsFile}.php;
      chown nginx:nginx ${saltsFile}.php;
      chmod 644 ${saltsFile}.php;
    '';
  };
  acme.certs = if useSSL then { "${exploringBlogUrl}".email = "nocoolnametom@gmail.com"; } else {};
  mysql = {
    initialDatabases = [];
    ensureDatabases = [
      dbName
    ];
    ensureUsers = [
      {
        name = dbUser;
        ensurePermissions = {
          "${dbName}.*" = "ALL";
        };
      }
    ];
  };
  mysqlBackup = {
    databases = [ dbName ];
  };
  phpfpm.poolConfigs."${exploringBlogUrl}" = ''
    listen = /var/run/${exploringBlogUrl}-phpfpm.sock
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
  services.fail2ban.enable = true;
  users.extraGroups."${dbUser}".gid = 499;
  users.extraUsers."${dbUser}" = {
    uid = 1048;
    group = "${dbUser}";
    extraGroups = [ "nginx" ];
  };
  nginx.virtualHosts."${exploringBlogUrl}" = {
    forceSSL = useSSL;
    enableACME = useSSL;
    http2 = useSSL;
    serverAliases = [ "www.${exploringBlogUrl}" ];
    root = "${wordpressRoot}/public";
    locations = {
      "= /favicon.ico" = {
        extraConfig = ''
          log_not_found off;
          access_log off;
        '';
      };
      "= /robots.txt" = {
        extraConfig = ''
          allow all;
          log_not_found off;
          access_log off;
        '';
      };
      "/" = {
        index = "index.php index.html";
        extraConfig = ''
          if ($http_user_agent ~ "(agent1|Wget|Catall Spider)" ) {
            return 403;
          }
          if (-e $request_filename) {
            rewrite ^/(wp-(content|admin|includes).*) /$1 break;
          }
          rewrite ^/(.*\.php)$ /$1 break;
        '';
        tryFiles = "$uri $uri/ /index.php$is_args$args";
      };
      "~ \.php$" = {
        tryFiles = "$uri =404";
        extraConfig = ''
          fastcgi_pass unix:/var/run/${exploringBlogUrl}-phpfpm.sock;
          fastcgi_index index.php;
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
          fastcgi_intercept_errors on;
          expires -1;
        '';
      };
      ## Hardening Wordpress
      "~* wp-admin/includes" = { extraConfig = "deny all;"; };
      "~* wp-includes/theme-compat/" = { extraConfig = "deny all;"; };
      "~* wp-includes/js/tinymce/langs/.*.php" = { extraConfig = "deny all;"; };
      "/wp-includes/" =  { extraConfig = "internal;"; };
      ## block any attempted XML-RPC requests
      "/xmlrpc.php" = { extraConfig = "deny all;"; };
      ## block attempting to run any uploaded PHP file
      "~* /(?:uploads|files)/.*\.php$" = { extraConfig = "deny all;"; };
      ## Converted WP .htaccess file
      "/wp-admin" = {
        extraConfig = ''
          rewrite ^/wp-admin$ /wp-admin/ redirect;
        '';
      };
      ## Have resources live long and prosper
      "~* \.(css|js|gif|ico|jpe?g|png)$" = {
        extraConfig = ''
          expires 168h;
          add_header Pragma public;
          add_header Cache-Control "public, must-revalidate, proxy-revalidate";
        '';
      };
    };
  };
}
