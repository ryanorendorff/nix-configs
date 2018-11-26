{ pkgs ? import <nixpkgs> {}, dbName ? "", dbUser ? "", dbPassword ? "", dbHost ? "localhost", tablePrefix ? "wp_", extraConfig ? "", saltsFile ? "", ... }:

pkgs.writeTextFile {
  name = "${builtins.toString builtins.currentTime}wp-config.php";
  text = ''
    <?php
    define('DB_NAME',     '${dbName}');
    define('DB_USER',     '${dbUser}');
    define('DB_PASSWORD', '${dbPassword}');
    define('DB_HOST',     '${dbHost}');
    define('DB_CHARSET',  'utf8');
    $table_prefix  = '${tablePrefix}';
    define('AUTOMATIC_UPDATER_DISABLED', true);
    define('DISALLOW_FILE_MODS', true );
    ${extraConfig}
    if ( !defined('ABSPATH') )
      define('ABSPATH', dirname(__FILE__) . '/');
    try {
      if ('${saltsFile}' !== "" && file_exists('${saltsFile}.php')) {
        require_once('${saltsFile}.php');
      }
    } catch (\Exception $e) { unset($e); }
    require_once(ABSPATH . 'wp-settings.php');
  '';
}
