{ pkgs, ...}:

pkgs.writeText "npmrc" ''
  prefix=${builtins.getEnv "HOME"}/.npm
  @premieragent:registry=http://npm-int-0-1.sv2.trulia.com:8080/
''