{ pkgs, ...}:

with pkgs; with python36Packages; with mine.python36Packages;

callPackage ../../python-modules/apopscli {
  inherit consul;
  inherit cement;
  inherit fetchpypi;
  inherit yamlordereddictloader;
  inherit zcookiecutter;
  inherit python-gitlab;
}
