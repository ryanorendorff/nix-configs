{
  pkgs,
  dbName ? "",
  dbUser ? "root",
  dbPassword ? "",
  dbHost ? "",
  ...
}:

let
  codeVersion = "1.0.2";
  sqlVersion = "sqldump_1.1";
  sourceForCode = (builtins.fetchTarball "https://gitlab.com/nocoolnametom/journalofdiscourses/-/archive/${codeVersion}/journalofdiscourses-${codeVersion}.tar.gz")
  sourceForSql = (builtins.fetchTarball "https://gitlab.com/nocoolnametom/journalofdiscourses/-/archive/${sqlVersion}/journalofdiscourses-${sqlVersion}.tar.gz");
  injectValuesIntoSqlPermissions = import (builtins.toPath sourceForCode);
in {
  inherit (import (builtins.toPath (sourceForCode + "/release.nix")) {
    inherit dbName dbUser dbPassword dbHost;
  }); # Returns 'package' and 'rewrites'
  sqlDataFile = (builtins.toPath (sourceForSql + "/data.sql"));
  permissionSql = (import (builtins.toPath (sourceForSql + "/default.nix")) {
    inherit dbName dbUser dbPassword dbHost;
  }) + "/permissions.sql";
}
