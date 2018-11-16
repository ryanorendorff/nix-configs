{
  pkgs,
  dbName ? "",
  dbUser ? "root",
  dbPassword ? "",
  dbHost ? "",
  ...
}:

let
  codeVersion = "1.1.0";
  sqlVersion = "sqldump_1.2";
  sourceForCode = (builtins.fetchTarball "https://gitlab.com/nocoolnametom/journalofdiscourses/-/archive/${codeVersion}/journalofdiscourses-${codeVersion}.tar.gz");
  injectValuesIntoSource = import (builtins.toPath (sourceForCode + "/release.nix"));
  sourceForSql = (builtins.fetchTarball "https://gitlab.com/nocoolnametom/journalofdiscourses/-/archive/${sqlVersion}/journalofdiscourses-${sqlVersion}.tar.gz");
  injectValuesIntoSqlPermissions = import (builtins.toPath sourceForSql + "/default.nix");
in {
  # Returns 'package' and 'rewrites'
  sqlDataFile = (builtins.toPath (sourceForSql + "/data.sql"));
  permissionSql = (injectValuesIntoSqlPermissions {
    inherit dbName dbUser dbPassword;
  }) + "/permissions.sql";
} // (injectValuesIntoSource {
  inherit dbName dbUser dbPassword dbHost;
})
