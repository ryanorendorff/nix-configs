{
  pkgs,
  dbName ? "",
  dbUser ? "root",
  dbPassword ? "",
  dbHost ? "",
  ...
}:

let
  codeVersion = "1.0.0";
  sqlVersion = "sqldump_1.0";
  sourceForCode = (builtins.fetchTarball "https://gitlab.com/nocoolnametom/mormonquotes/-/archive/${codeVersion}/mormonquotes-${codeVersion}.tar.gz");
  injectValuesIntoSource = import (builtins.toPath (sourceForCode + "/release.nix"));
  sourceForSql = (builtins.fetchTarball "https://gitlab.com/nocoolnametom/mormonquotes/-/archive/${sqlVersion}/mormonquotes-${sqlVersion}.tar.gz");
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
