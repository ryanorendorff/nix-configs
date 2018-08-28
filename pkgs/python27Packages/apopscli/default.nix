{ pkgs, ...}:

with pkgs; with python27Packages; with mine.python27Packages;

callPackage ../../python-modules/apopscli {
  inherit consul;
  inherit cement;
  inherit fetchpypi;
  inherit yamlordereddictloader;
  inherit zcookiecutter;
  inherit python-gitlab;
}
